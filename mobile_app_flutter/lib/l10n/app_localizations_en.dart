// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Agent Ab';

  @override
  String get navAgent => 'AI Agent';

  @override
  String get navHistory => 'History';

  @override
  String get navScans => 'Scans';

  @override
  String get navScanLink => 'Link';

  @override
  String get navScanImage => 'Image';

  @override
  String get scanLinkScreenTitle => 'Scan Link';

  @override
  String get scanLinkScreenSubtitle => 'Analyze suspicious URLs instantly';

  @override
  String get scanSuspiciousUrlLabel => 'Suspicious URL';

  @override
  String get scanLinkAction => 'Scan';

  @override
  String get scanAnalyzingLink => 'Analyzing link…';

  @override
  String get scanImageScreenTitle => 'Scan Image';

  @override
  String get scanImageScreenSubtitle => 'Check if image looks AI-generated';

  @override
  String get scanChooseImageOrCamera => 'Choose image or camera';

  @override
  String get scanNoFileChosen => 'No file chosen';

  @override
  String get scanAnalyzeAction => 'Analyze';

  @override
  String get scanAnalyzingImage => 'Analyzing image…';

  @override
  String get navSettings => 'Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSubtitle => 'Switch between English and Arabic';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSubtitle =>
      'Use light mode, dark mode, or match your device';

  @override
  String get langEnglish => 'English';

  @override
  String get langArabic => 'Arabic';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsFontSize => 'Text size';

  @override
  String get settingsFontSizeSubtitle => 'Scale text across the app';

  @override
  String get fontSizeCompact => 'Compact';

  @override
  String get fontSizeStandard => 'Default';

  @override
  String get fontSizeComfortable => 'Comfortable';

  @override
  String get settingsBackend => 'Backend';

  @override
  String get settingsBaseUrl => 'Base URL';

  @override
  String get settingsBaseUrlHint => 'http://10.0.2.2:5000';

  @override
  String get settingsSaveUrl => 'Save URL';

  @override
  String get settingsHealthCheck => 'GET /health';

  @override
  String get settingsUrlSaved => 'Backend URL saved.';

  @override
  String get settingsAgentMode => 'Agent mode';

  @override
  String get settingsAutoAgentTitle => 'Automatic agent (Android)';

  @override
  String get settingsAutoAgentSubtitle =>
      'Sends periodic POST /agent/auto-tick with source=auto while the app runs.';

  @override
  String get settingsManualOnlyTitle => 'Manual only (iOS)';

  @override
  String get settingsManualOnlySubtitle =>
      'iOS builds do not enable automatic background agent ticks in this template.';

  @override
  String get settingsCopyUrl => 'Copy resolved URL';

  @override
  String get settingsCopied => 'Copied base URL';

  @override
  String get healthOkEmpty => 'OK (empty body)';

  @override
  String get chatTitle => 'Agent Ab · AI';

  @override
  String get chatClearTooltip => 'Clear chat';

  @override
  String get chatDismiss => 'Dismiss';

  @override
  String get chatHint => 'Message the backend AI…';

  @override
  String get historyTitle => 'Chat history';

  @override
  String get historyTitleDetail => 'Conversation';

  @override
  String get historyEmpty => 'No saved conversations yet.';

  @override
  String historyMessageCount(int count) {
    return '$count messages';
  }

  @override
  String get historyDeleteTooltip => 'Delete conversation';

  @override
  String get securityScansTitle => 'Security scans';

  @override
  String get scanNoteAndroidAuto =>
      'Android automatic agent is on: the backend also receives periodic `/agent/auto-tick` with source=auto.';

  @override
  String get scanNoteManual =>
      'All scans from this screen use source=manual (required on iOS).';

  @override
  String get scanManualTitle => 'Manual security scan';

  @override
  String get scanLinkLabel => 'Link URL';

  @override
  String get scanLinkHint => 'https://example.com/login';

  @override
  String get scanScanLink => 'Scan link';

  @override
  String get scanImageLabel => 'Image name';

  @override
  String get scanImageHint => 'suspected_generated_image.png';

  @override
  String get scanScanImage => 'Scan image';

  @override
  String get scanErrorUrl => 'Enter a URL first.';

  @override
  String get scanErrorImage => 'Enter an image file name first.';

  @override
  String scanType(Object type) {
    return 'Type: $type';
  }

  @override
  String scanSource(Object source) {
    return 'Source: $source';
  }

  @override
  String scanLabelLine(Object label) {
    return 'Label: $label';
  }

  @override
  String scanScore(Object score) {
    return 'Score: $score';
  }

  @override
  String scanReason(Object reason) {
    return 'Reason: $reason';
  }

  @override
  String get historyTabChat => 'Chats';

  @override
  String get historyTabScans => 'Scan log';

  @override
  String get scanHistoryEmpty =>
      'No scans in your log yet. Use Link or Image to run a scan — results appear here while “Save scan history” is on (it’s on by default).';

  @override
  String get scanHistoryClear => 'Clear scan log';

  @override
  String riskLevel(Object level) {
    return 'Risk: $level';
  }

  @override
  String get riskSummary => 'Assessment';

  @override
  String get shareReport => 'Share report';

  @override
  String get copyReport => 'Copy report';

  @override
  String get reportCopied => 'Report copied';

  @override
  String get scanOpenLinkInBrowser => 'Open link';

  @override
  String get scanCopyLinkAddress => 'Copy link';

  @override
  String get scanOpenLinkDialogTitle => 'Open in browser?';

  @override
  String get scanOpenLinkDialogBody =>
      'This link was flagged or analyzed in the app only. Opening it in an external browser can still be risky (phishing, malware, or scams). Continue only if you understand the risk.';

  @override
  String get scanOpenLinkDialogCancel => 'Cancel';

  @override
  String get scanOpenLinkDialogOpen => 'Open anyway';

  @override
  String get scanCouldNotOpenLink => 'Could not open this link on the device.';

  @override
  String get scanUrlCopiedWithWarning =>
      'Link copied. Do not open it unless you trust it — it may still be dangerous.';

  @override
  String get pickGallery => 'Gallery';

  @override
  String get pickCamera => 'Camera';

  @override
  String get scanUploadImage => 'Scan uploaded image';

  @override
  String get typingIndicator => 'Assistant is typing…';

  @override
  String get regenerate => 'Regenerate';

  @override
  String get copyMessage => 'Copy';

  @override
  String get messageCopied => 'Message copied';

  @override
  String get highRiskTitle => 'Possible phishing or risky link';

  @override
  String get highRiskBody =>
      'We flagged content from your clipboard. Open the app to review.';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginEmailHint => 'Email or username';

  @override
  String get loginPasswordHint => 'Password';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginGoogle => 'Continue with Google';

  @override
  String get loginApple => 'Continue with Apple';

  @override
  String get loginGuest => 'Continue without account';

  @override
  String get loginError => 'Sign-in failed';

  @override
  String get loginErrorEnterEmail => 'Enter your email or username.';

  @override
  String get loginErrorInvalidEmail =>
      'That doesn’t look like a valid email address.';

  @override
  String get loginErrorAccountNotFound =>
      'No account found for this email. Check the address or sign up.';

  @override
  String get loginErrorWrongPassword =>
      'Wrong password. Try again or reset your password.';

  @override
  String get loginShowPassword => 'Show password';

  @override
  String get loginHidePassword => 'Hide password';

  @override
  String get logout => 'Sign out';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsSaveChatHistory => 'Save AI chat history on device';

  @override
  String get settingsSaveChatHistorySubtitle =>
      'Off by default. Chats stay in memory only unless you enable this.';

  @override
  String get settingsSaveScanHistory => 'Save scan results on device';

  @override
  String get settingsSaveScanHistorySubtitle =>
      'Stores links and images you scanned with risk summaries. On by default; turn off to stop adding new scans to the log.';

  @override
  String get settingsAboutPrivacySection => 'About & privacy';

  @override
  String get settingsAboutAppShort =>
      'Agent Ab helps you check suspicious links and images using your configured backend. Scans and optional chat may be sent to your server — see your deployment’s policy.';

  @override
  String get settingsPrivacyShort =>
      'We don’t operate a central cloud for this template: data goes to the backend URL you set. Enable or disable saving chat/scan history on this device in the switches above.';

  @override
  String get settingsOpenPrivacyPolicy => 'Open full privacy policy';

  @override
  String get settingsAutoAgentSubtitleAndroid =>
      'Foreground only while the app is open: periodic check-in with the server, optional clipboard scan when you return to the app, and a local alert if something looks like phishing. Does not monitor other apps in the background. iOS stays manual only.';

  @override
  String get scanFromClipboardTitle => 'Clipboard link scanned';

  @override
  String get scanFromClipboardDismiss => 'OK';
}
