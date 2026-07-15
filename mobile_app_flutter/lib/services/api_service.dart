import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../core/login_error_parser.dart';
import '../models/ai_chat_response.dart';
import '../models/chat_message.dart';
import '../models/scan_result.dart';
import 'api_exception.dart';

/// HTTP client for Agent Ab backend + AI endpoints.
///
/// Routes (adjust to your server):
/// - `GET /health`
/// - `POST /auth/login` `{ "email", "password" }` → `{ "access_token": "..." }`
///   On failure (4xx), JSON like `{ "error": "user_not_found" }` or `{ "detail": "Wrong password" }`
///   is parsed so the app can show account-not-found vs wrong-password (see [parseLoginFailureKind]).
/// - `POST /auth/google` `{ "id_token": "..." }`
/// - `POST /auth/apple` `{ "id_token", "authorization_code" }`
/// - `POST /scan/link` `{ "url", "source"         }`
/// - `POST /scan/image` `{ "image_name", "source" }`
/// - `POST /scan/image-upload` multipart `file`, `source`
/// - `POST /ai/chat` …
/// - `POST /agent/auto-tick` …
class ApiService {
  ApiService({
    required this.baseUrl,
    this.getToken,
    http.Client? client,
    this.timeout = const Duration(seconds: 25),
    this.maxRetries = 2,
  }) : _client = client ?? http.Client();

  final String Function() baseUrl;
  final String? Function()? getToken;
  final http.Client _client;
  final Duration timeout;
  final int maxRetries;

  Uri _uri(String path) {
    final root = baseUrl().replaceAll(RegExp(r'/+$'), '');
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$root$p');
  }

  Map<String, String> _jsonHeaders() {
    final h = <String, String>{'Content-Type': 'application/json'};
    final t = getToken?.call();
    if (t != null && t.isNotEmpty) {
      h['Authorization'] = 'Bearer $t';
    }
    return h;
  }

  Map<String, String> _authOnlyHeaders() {
    final t = getToken?.call();
    if (t == null || t.isEmpty) return {};
    return {'Authorization': 'Bearer $t'};
  }

  Future<http.Response> _withRetry(
    Future<http.Response> Function() request,
  ) async {
    var attempt = 0;
    Object? lastError;
    while (attempt <= maxRetries) {
      try {
        final response = await request().timeout(timeout);
        if (_shouldRetryStatus(response.statusCode) &&
            attempt < maxRetries) {
          attempt++;
          await Future<void>.delayed(Duration(milliseconds: 400 * attempt));
          continue;
        }
        return response;
      } on SocketException catch (e) {
        lastError = e;
        if (attempt >= maxRetries) {
          throw ApiException(
            'Network error. Check your connection and server address.',
            cause: e,
          );
        }
        attempt++;
        await Future<void>.delayed(Duration(milliseconds: 400 * attempt));
      } on TimeoutException catch (e) {
        lastError = e;
        if (attempt >= maxRetries) {
          throw ApiException(
            'Request timed out. The server may be slow or unreachable.',
            cause: e,
          );
        }
        attempt++;
      } on HandshakeException catch (e) {
        throw ApiException(
          'Secure connection failed. Use HTTPS with a valid certificate in production.',
          cause: e,
        );
      } on TlsException catch (e) {
        throw ApiException(
          'TLS error. Check HTTPS configuration on the server.',
          cause: e,
        );
      } on http.ClientException catch (e) {
        lastError = e;
        if (attempt >= maxRetries) {
          throw ApiException(
            'Could not reach the server (${e.message}).',
            cause: e,
          );
        }
        attempt++;
      } catch (e) {
        throw ApiException('Unexpected error: $e', cause: e);
      }
    }
    throw ApiException('Request failed after retries.', cause: lastError);
  }

  bool _shouldRetryStatus(int code) {
    return code == 502 || code == 503 || code == 504;
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    final snippet = response.body.length > 280
        ? '${response.body.substring(0, 280)}…'
        : response.body;
    throw ApiException(
      'Server returned ${response.statusCode}. ${snippet.isNotEmpty ? snippet : "(no body)"}',
      statusCode: response.statusCode,
    );
  }

  Future<Map<String, dynamic>> health() async {
    final response = await _withRetry(
      () => _client.get(_uri('/health'), headers: _authOnlyHeaders()),
    );
    _ensureSuccess(response);
    if (response.body.isEmpty) return {};
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> loginEmail({
    required String email,
    required String password,
  }) async {
    final response = await _withRetry(
      () => _client.post(
        _uri('/auth/login'),
        headers: _jsonHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      ),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    final snippet = response.body.length > 280
        ? '${response.body.substring(0, 280)}…'
        : response.body;
    final kind = parseLoginFailureKind(response.statusCode, response.body);
    throw ApiException(
      'Server returned ${response.statusCode}. ${snippet.isNotEmpty ? snippet : "(no body)"}',
      statusCode: response.statusCode,
      loginFailureKind: kind,
    );
  }

  Future<Map<String, dynamic>> loginGoogle({required String idToken}) async {
    final response = await _withRetry(
      () => _client.post(
        _uri('/auth/google'),
        headers: _jsonHeaders(),
        body: jsonEncode({'id_token': idToken}),
      ),
    );
    _ensureSuccess(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> loginApple({
    required String identityToken,
    String? authorizationCode,
  }) async {
    final response = await _withRetry(
      () => _client.post(
        _uri('/auth/apple'),
        headers: _jsonHeaders(),
        body: jsonEncode({
          'id_token': identityToken,
          if (authorizationCode != null)
            'authorization_code': authorizationCode,
        }),
      ),
    );
    _ensureSuccess(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<ScanResult> scanLink(String url, {required String source}) async {
    final response = await _withRetry(
      () => _client.post(
        _uri('/scan/link'),
        headers: _jsonHeaders(),
        body: jsonEncode({'url': url, 'source': source}),
      ),
    );
    _ensureSuccess(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return ScanResult.fromJson(body);
  }

  Future<ScanResult> scanImageName(String imageName, {required String source}) async {
    final response = await _withRetry(
      () => _client.post(
        _uri('/scan/image'),
        headers: _jsonHeaders(),
        body: jsonEncode({'image_name': imageName, 'source': source}),
      ),
    );
    _ensureSuccess(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return ScanResult.fromJson(body);
  }

  Future<ScanResult> scanImageUpload(
    XFile file, {
    required String source,
  }) async {
    Future<http.Response> send() async {
      final request = http.MultipartRequest('POST', _uri('/scan/image-upload'));
      request.headers.addAll(_authOnlyHeaders());
      request.fields['source'] = source;
      final bytes = await file.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: file.name,
        ),
      );
      final streamed = await request.send().timeout(timeout);
      return http.Response.fromStream(streamed);
    }

    final response = await _withRetry(send);
    _ensureSuccess(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return ScanResult.fromJson(body);
  }

  Future<AiChatResponse> chat({
    required List<ChatMessage> messages,
    required String source,
    String? sessionId,
  }) async {
    final response = await _withRetry(
      () => _client.post(
        _uri('/ai/chat'),
        headers: _jsonHeaders(),
        body: jsonEncode({
          'messages': messages.map((m) => m.toJson()).toList(),
          'source': source,
          if (sessionId != null) 'session_id': sessionId,
        }),
      ),
    );
    _ensureSuccess(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return AiChatResponse.fromJson(body);
  }

  Future<void> autoAgentTick({required String source}) async {
    final response = await _withRetry(
      () => _client.post(
        _uri('/agent/auto-tick'),
        headers: _jsonHeaders(),
        body: jsonEncode({
          'source': source,
          'platform': 'android',
        }),
      ),
    );
    _ensureSuccess(response);
  }
}
