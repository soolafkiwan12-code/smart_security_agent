import 'core/platform_capabilities.dart';

/// Default backend URLs. Override in Settings at runtime.
class AppConfig {
  /// Set to `false` in production to require real authentication (no guest).
  static const bool authGuestAllowed = true;

  /// Android emulator → host machine
  static const String defaultBaseUrlAndroidEmulator = 'http://10.0.2.2:5000';

  /// iOS simulator / physical device on same LAN (adjust IP for device testing)
  static const String defaultBaseUrlIosSimulator = 'http://127.0.0.1:5000';

  static String defaultBaseUrlForPlatform() {
    if (platformIsAndroid) return defaultBaseUrlAndroidEmulator;
    if (platformIsIos) return defaultBaseUrlIosSimulator;
    return defaultBaseUrlIosSimulator;
  }

  /// Full privacy policy URL (HTTPS). Leave empty to hide the “open policy” button in Settings.
  static const String privacyPolicyUrl = '';
}
