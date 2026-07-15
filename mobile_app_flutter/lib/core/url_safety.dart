/// Result of validating a user-entered URL before calling the backend.
sealed class UrlValidationResult {}

class UrlValid extends UrlValidationResult {
  UrlValid(this.normalizedUrl);
  final String normalizedUrl;
}

class UrlInvalid extends UrlValidationResult {
  UrlInvalid(this.reason);
  final String reason;
}

/// Allows only `http:` / `https:` after normalization. Blocks `javascript:`,
/// `data:`, `file:`, and other schemes.
class UrlSafety {
  UrlSafety._();

  static final RegExp _urlLike =
      RegExp(r'^(https?:)?//', caseSensitive: false);

  static final RegExp _extractHttp =
      RegExp(r'https?://[^\s]+', caseSensitive: false);

  /// Best-effort extraction when clipboard holds surrounding text.
  static String? firstHttpUrlIn(String text) {
    final m = _extractHttp.firstMatch(text);
    return m?.group(0);
  }

  /// Trim, add https if scheme missing, validate host exists, scheme allowed.
  static UrlValidationResult validateHttpUrl(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return UrlInvalid('Empty URL.');
    }

    final lower = trimmed.toLowerCase();
    if (lower.startsWith('javascript:') ||
        lower.startsWith('data:') ||
        lower.startsWith('file:') ||
        lower.startsWith('vbscript:')) {
      return UrlInvalid(
        'Blocked URL scheme. Only http and https links are allowed.',
      );
    }

    String candidate = trimmed;
    if (!_urlLike.hasMatch(candidate) &&
        !candidate.contains(':')) {
      candidate = 'https://$candidate';
    }

    final uri = Uri.tryParse(candidate);
    if (uri == null) {
      return UrlInvalid('Could not parse this as a URL.');
    }

    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return UrlInvalid(
        'Only http and https are allowed (got "${uri.scheme}").',
      );
    }

    if (uri.host.isEmpty) {
      return UrlInvalid('Missing hostname.');
    }

    final normalized = uri.toString();
    return UrlValid(normalized);
  }
}
