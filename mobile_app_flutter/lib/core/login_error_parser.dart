import 'dart:convert';

import '../services/api_exception.dart';

/// Interprets common API shapes so email login can show "unknown account" vs "wrong password".
///
/// Backend examples this recognizes:
/// - JSON `{ "error": "user_not_found" }`, `{ "code": "WRONG_PASSWORD" }`, FastAPI `{ "detail": "..." }`, etc.
/// - Plain-text body containing phrases like "user not found" or "invalid password".
LoginFailureKind? parseLoginFailureKind(int statusCode, String body) {
  const interesting = {400, 401, 403, 404, 422};
  if (!interesting.contains(statusCode)) return null;

  Map<String, dynamic>? map;
  try {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) map = decoded;
  } catch (_) {}

  if (map != null) {
    final fromFields = _kindFromMap(map);
    if (fromFields != null) return fromFields;
  }

  final lower = body.toLowerCase();
  if (_impliesAccountMissing(lower)) return LoginFailureKind.accountNotFound;
  if (_impliesWrongPassword(lower)) return LoginFailureKind.wrongPassword;
  return null;
}

LoginFailureKind? _kindFromMap(Map<String, dynamic> j) {
  final tokens = <String>[];

  void add(dynamic v) {
    if (v == null) return;
    if (v is String) tokens.add(v.toLowerCase());
    if (v is num) tokens.add(v.toString().toLowerCase());
  }

  add(j['error']);
  add(j['error_code']);
  add(j['code']);
  add(j['message']);
  add(j['msg']);

  final detail = j['detail'];
  if (detail is String) {
    tokens.add(detail.toLowerCase());
  } else if (detail is List) {
    for (final item in detail) {
      if (item is Map && item['msg'] is String) {
        add(item['msg']);
      }
    }
  }

  for (final t in tokens) {
    if (_tokenAccountMissing(t)) return LoginFailureKind.accountNotFound;
  }
  for (final t in tokens) {
    if (_tokenWrongPassword(t)) return LoginFailureKind.wrongPassword;
  }
  return null;
}

bool _tokenAccountMissing(String t) {
  return t.contains('user_not_found') ||
      t.contains('email_not_found') ||
      t.contains('unknown_user') ||
      t.contains('no_such_user') ||
      t.contains('account_not_found') ||
      t.contains('user does not exist') ||
      t.contains('not registered') ||
      (t.contains('user') && t.contains('not found')) ||
      (t.contains('email') && t.contains('unknown'));
}

bool _tokenWrongPassword(String t) {
  return t.contains('wrong_password') ||
      t.contains('bad_password') ||
      t.contains('invalid_password') ||
      t.contains('incorrect password') ||
      t.contains('wrong password') ||
      t == 'invalid_credentials' ||
      t.contains('invalid credentials') ||
      (t.contains('password') && t.contains('incorrect'));
}

bool _impliesAccountMissing(String lower) {
  return lower.contains('user not found') ||
      lower.contains('email not found') ||
      lower.contains('no user') ||
      lower.contains('unknown email') ||
      lower.contains('account does not exist');
}

bool _impliesWrongPassword(String lower) {
  return lower.contains('invalid password') ||
      lower.contains('wrong password') ||
      lower.contains('incorrect password') ||
      lower.contains('bad credentials');
}
