import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config.dart';
import 'api_exception.dart';
import 'api_service.dart';

const _kAccessTokenKey = 'agent_ab_access_token';

/// Stores JWT / access token and guest mode for login gating.
class AuthService extends ChangeNotifier {
  AuthService();

  final FlutterSecureStorage _secure = const FlutterSecureStorage();
  String? _token;

  String? get accessToken => _token;

  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  bool isGuest = false;

  bool get canUseApp =>
      isAuthenticated || (AppConfig.authGuestAllowed && isGuest);

  Future<void> hydrate() async {
    try {
      _token = await _secure.read(key: _kAccessTokenKey);
    } catch (_) {
      _token = null;
    }
    notifyListeners();
  }

  Future<void> _persistToken(String? token) async {
    _token = token;
    if (token == null || token.isEmpty) {
      await _secure.delete(key: _kAccessTokenKey);
    } else {
      await _secure.write(key: _kAccessTokenKey, value: token);
    }
    isGuest = false;
    notifyListeners();
  }

  static String? extractTokenFromBody(Map<String, dynamic> body) {
    return body['access_token']?.toString() ??
        body['token']?.toString() ??
        body['accessToken']?.toString();
  }

  Future<void> loginWithEmailPassword(
    ApiService api, {
    required String principal,
    required String password,
  }) async {
    final body =
        await api.loginEmail(email: principal.trim(), password: password);
    final token = extractTokenFromBody(body);
    if (token == null || token.isEmpty) {
      throw const ApiException(
        'Login succeeded but no access token was returned.',
      );
    }
    await _persistToken(token);
  }

  Future<void> loginWithGoogle(ApiService api, String idToken) async {
    final body = await api.loginGoogle(idToken: idToken);
    final token = extractTokenFromBody(body);
    if (token == null || token.isEmpty) {
      throw const ApiException(
        'Google sign-in succeeded but no access token was returned.',
      );
    }
    await _persistToken(token);
  }

  Future<void> loginWithApple(
    ApiService api, {
    required String identityToken,
    String? authorizationCode,
  }) async {
    final body = await api.loginApple(
      identityToken: identityToken,
      authorizationCode: authorizationCode,
    );
    final token = extractTokenFromBody(body);
    if (token == null || token.isEmpty) {
      throw const ApiException(
        'Apple sign-in succeeded but no access token was returned.',
      );
    }
    await _persistToken(token);
  }

  void continueAsGuest() {
    if (!AppConfig.authGuestAllowed) return;
    isGuest = true;
    notifyListeners();
  }

  Future<void> logout() async {
    isGuest = false;
    await _persistToken(null);
  }
}
