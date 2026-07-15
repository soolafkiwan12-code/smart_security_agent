/// When [loginEmail] fails, the backend can signal this so the UI shows a clearer message.
enum LoginFailureKind {
  accountNotFound,
  wrongPassword,
}

/// Maps HTTP / network failures to clearer client messages.
class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.cause,
    this.loginFailureKind,
  });

  final String message;
  final int? statusCode;
  final Object? cause;
  final LoginFailureKind? loginFailureKind;

  @override
  String toString() => message;
}
