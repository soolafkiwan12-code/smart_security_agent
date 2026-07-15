import 'dart:async';

import '../core/platform_capabilities.dart';
import 'api_service.dart';
import 'settings_service.dart';

/// Foreground timer: Android + automatic mode only. Backend receives periodic
/// [POST /agent/auto-tick] with `source: auto` for AI / orchestration hooks.
class AutomaticAgentScheduler {
  AutomaticAgentScheduler({
    required this.settings,
    required this.api,
    this.interval = const Duration(minutes: 2),
  });

  final SettingsService settings;
  final ApiService api;
  final Duration interval;

  Timer? _timer;

  void start() {
    stop();
    if (!platformSupportsAutomaticAgent) return;
    if (!settings.androidAutomaticAgentEnabled) return;
    _timer = Timer.periodic(interval, (_) => _tick());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _tick() async {
    if (!settings.androidAutomaticAgentEnabled) return;
    try {
      await api.autoAgentTick(source: settings.sourceAuto);
    } catch (_) {
      // Avoid crashing the isolate; surface errors via logs / health UI later.
    }
  }

  void syncWithSettings() {
    if (platformSupportsAutomaticAgent && settings.androidAutomaticAgentEnabled) {
      start();
    } else {
      stop();
    }
  }
}
