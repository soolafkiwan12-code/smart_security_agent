import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Local notifications for high-risk findings (Android automatic / clipboard flow).
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  int _id = 9000;

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> showSecurityAlert({
    required String title,
    required String body,
  }) async {
    try {
      const android = AndroidNotificationDetails(
        'agent_ab_security',
        'Security alerts',
        channelDescription: 'Alerts for suspicious links or content',
        importance: Importance.high,
        priority: Priority.high,
      );
      const ios = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      const details = NotificationDetails(android: android, iOS: ios);
      await _plugin.show(_id++, title, body, details);
    } catch (e, st) {
      debugPrint('NotificationService.show failed: $e $st');
    }
  }
}
