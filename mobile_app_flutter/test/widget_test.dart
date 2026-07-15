import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_security_agent_app/services/auth_service.dart';
import 'package:smart_security_agent_app/services/settings_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Guest mode and privacy defaults', () async {
    SharedPreferences.setMockInitialValues({});
    final settings = await SettingsService.load();
    final auth = AuthService();
    await auth.hydrate();
    auth.continueAsGuest();

    expect(auth.canUseApp, isTrue);
    expect(settings.saveChatHistoryEnabled, isFalse);
    expect(settings.saveScanHistoryEnabled, isTrue);
  });
}
