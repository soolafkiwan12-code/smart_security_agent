import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../core/platform_capabilities.dart';

const _kBaseUrlKey = 'agent_ab_base_url';
const _kAndroidAutoAgentKey = 'agent_ab_android_auto_agent';
const _kLanguageKey = 'agent_ab_language';
const _kThemeKey = 'agent_ab_theme';
const _kFontSizeKey = 'agent_ab_font_size';
const _kSaveChatHistoryKey = 'agent_ab_save_chat_history';
const _kSaveScanHistoryKey = 'agent_ab_save_scan_history';

enum AppThemePreference { system, light, dark }

/// App-wide text scale (combined with system accessibility text scaling).
enum AppFontSizePreference { compact, standard, comfortable }

/// Persisted user settings: backend URL and Android-only automatic agent mode.
class SettingsService extends ChangeNotifier {
  SettingsService._(this._prefs);

  final SharedPreferences _prefs;

  /// For services that share the same preferences file (e.g. chat history).
  SharedPreferences get preferences => _prefs;

  static Future<SettingsService> load() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsService._(prefs);
  }

  String? get baseUrlOverride {
    final v = _prefs.getString(_kBaseUrlKey);
    if (v == null || v.trim().isEmpty) return null;
    return v.trim();
  }

  Future<void> setBaseUrlOverride(String? value) async {
    if (value == null || value.trim().isEmpty) {
      await _prefs.remove(_kBaseUrlKey);
    } else {
      await _prefs.setString(_kBaseUrlKey, value.trim());
    }
    notifyListeners();
  }

  /// Meaningful only on Android; ignored on iOS in UI and logic.
  bool get androidAutomaticAgentEnabled {
    if (!platformSupportsAutomaticAgent) return false;
    return _prefs.getBool(_kAndroidAutoAgentKey) ?? false;
  }

  Future<void> setAndroidAutomaticAgentEnabled(bool value) async {
    if (!platformSupportsAutomaticAgent) return;
    await _prefs.setBool(_kAndroidAutoAgentKey, value);
    notifyListeners();
  }

  String get resolvedBaseUrl =>
      baseUrlOverride ?? AppConfig.defaultBaseUrlForPlatform();

  /// User-initiated actions always use [manual] for clear audit on the backend.
  String get sourceManual => 'manual';

  /// Android automatic scheduler / ticks use this when enabled.
  String get sourceAuto => 'auto';

  /// `en` or `ar`.
  String get languageCode => _prefs.getString(_kLanguageKey) ?? 'en';

  Future<void> setLanguageCode(String code) async {
    if (code != 'en' && code != 'ar') return;
    await _prefs.setString(_kLanguageKey, code);
    notifyListeners();
  }

  Locale get locale => Locale(languageCode);

  AppThemePreference get themePreference {
    final v = _prefs.getString(_kThemeKey) ?? 'dark';
    switch (v) {
      case 'light':
        return AppThemePreference.light;
      case 'system':
        return AppThemePreference.system;
      case 'dark':
        return AppThemePreference.dark;
      default:
        return AppThemePreference.dark;
    }
  }

  Future<void> setThemePreference(AppThemePreference value) async {
    await _prefs.setString(_kThemeKey, value.name);
    notifyListeners();
  }

  ThemeMode get materialThemeMode {
    switch (themePreference) {
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
      case AppThemePreference.system:
        return ThemeMode.system;
    }
  }

  AppFontSizePreference get fontSizePreference {
    final v = _prefs.getString(_kFontSizeKey) ?? 'standard';
    switch (v) {
      case 'compact':
        return AppFontSizePreference.compact;
      case 'comfortable':
        return AppFontSizePreference.comfortable;
      case 'standard':
      default:
        return AppFontSizePreference.standard;
    }
  }

  Future<void> setFontSizePreference(AppFontSizePreference value) async {
    await _prefs.setString(_kFontSizeKey, value.name);
    notifyListeners();
  }

  /// Multiplier applied on top of the platform [TextScaler] (see [AgentAbApp]).
  double get textSizeFactor {
    switch (fontSizePreference) {
      case AppFontSizePreference.compact:
        return 0.9;
      case AppFontSizePreference.standard:
        return 1.0;
      case AppFontSizePreference.comfortable:
        return 1.15;
    }
  }

  /// Privacy: persist AI chat for the History tab (off by default).
  bool get saveChatHistoryEnabled => _prefs.getBool(_kSaveChatHistoryKey) ?? false;

  Future<void> setSaveChatHistoryEnabled(bool value) async {
    await _prefs.setBool(_kSaveChatHistoryKey, value);
    notifyListeners();
  }

  /// Privacy: persist link/image scans with risk (on by default so History shows your scans).
  bool get saveScanHistoryEnabled => _prefs.getBool(_kSaveScanHistoryKey) ?? true;

  Future<void> setSaveScanHistoryEnabled(bool value) async {
    await _prefs.setBool(_kSaveScanHistoryKey, value);
    notifyListeners();
  }
}
