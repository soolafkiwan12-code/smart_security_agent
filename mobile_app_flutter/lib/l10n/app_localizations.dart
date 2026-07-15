import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Agent Ab'**
  String get appTitle;

  /// No description provided for @navAgent.
  ///
  /// In en, this message translates to:
  /// **'AI Agent'**
  String get navAgent;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navScans.
  ///
  /// In en, this message translates to:
  /// **'Scans'**
  String get navScans;

  /// No description provided for @navScanLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get navScanLink;

  /// No description provided for @navScanImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get navScanImage;

  /// No description provided for @scanLinkScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Link'**
  String get scanLinkScreenTitle;

  /// No description provided for @scanLinkScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Analyze suspicious URLs instantly'**
  String get scanLinkScreenSubtitle;

  /// No description provided for @scanSuspiciousUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Suspicious URL'**
  String get scanSuspiciousUrlLabel;

  /// No description provided for @scanLinkAction.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanLinkAction;

  /// No description provided for @scanAnalyzingLink.
  ///
  /// In en, this message translates to:
  /// **'Analyzing link…'**
  String get scanAnalyzingLink;

  /// No description provided for @scanImageScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Image'**
  String get scanImageScreenTitle;

  /// No description provided for @scanImageScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check if image looks AI-generated'**
  String get scanImageScreenSubtitle;

  /// No description provided for @scanChooseImageOrCamera.
  ///
  /// In en, this message translates to:
  /// **'Choose image or camera'**
  String get scanChooseImageOrCamera;

  /// No description provided for @scanNoFileChosen.
  ///
  /// In en, this message translates to:
  /// **'No file chosen'**
  String get scanNoFileChosen;

  /// No description provided for @scanAnalyzeAction.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get scanAnalyzeAction;

  /// No description provided for @scanAnalyzingImage.
  ///
  /// In en, this message translates to:
  /// **'Analyzing image…'**
  String get scanAnalyzingImage;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch between English and Arabic'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use light mode, dark mode, or match your device'**
  String get settingsThemeSubtitle;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get langArabic;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsFontSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get settingsFontSize;

  /// No description provided for @settingsFontSizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scale text across the app'**
  String get settingsFontSizeSubtitle;

  /// No description provided for @fontSizeCompact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get fontSizeCompact;

  /// No description provided for @fontSizeStandard.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get fontSizeStandard;

  /// No description provided for @fontSizeComfortable.
  ///
  /// In en, this message translates to:
  /// **'Comfortable'**
  String get fontSizeComfortable;

  /// No description provided for @settingsBackend.
  ///
  /// In en, this message translates to:
  /// **'Backend'**
  String get settingsBackend;

  /// No description provided for @settingsBaseUrl.
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get settingsBaseUrl;

  /// No description provided for @settingsBaseUrlHint.
  ///
  /// In en, this message translates to:
  /// **'http://10.0.2.2:5000'**
  String get settingsBaseUrlHint;

  /// No description provided for @settingsSaveUrl.
  ///
  /// In en, this message translates to:
  /// **'Save URL'**
  String get settingsSaveUrl;

  /// No description provided for @settingsHealthCheck.
  ///
  /// In en, this message translates to:
  /// **'GET /health'**
  String get settingsHealthCheck;

  /// No description provided for @settingsUrlSaved.
  ///
  /// In en, this message translates to:
  /// **'Backend URL saved.'**
  String get settingsUrlSaved;

  /// No description provided for @settingsAgentMode.
  ///
  /// In en, this message translates to:
  /// **'Agent mode'**
  String get settingsAgentMode;

  /// No description provided for @settingsAutoAgentTitle.
  ///
  /// In en, this message translates to:
  /// **'Automatic agent (Android)'**
  String get settingsAutoAgentTitle;

  /// No description provided for @settingsAutoAgentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sends periodic POST /agent/auto-tick with source=auto while the app runs.'**
  String get settingsAutoAgentSubtitle;

  /// No description provided for @settingsManualOnlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual only (iOS)'**
  String get settingsManualOnlyTitle;

  /// No description provided for @settingsManualOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'iOS builds do not enable automatic background agent ticks in this template.'**
  String get settingsManualOnlySubtitle;

  /// No description provided for @settingsCopyUrl.
  ///
  /// In en, this message translates to:
  /// **'Copy resolved URL'**
  String get settingsCopyUrl;

  /// No description provided for @settingsCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied base URL'**
  String get settingsCopied;

  /// No description provided for @healthOkEmpty.
  ///
  /// In en, this message translates to:
  /// **'OK (empty body)'**
  String get healthOkEmpty;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Agent Ab · AI'**
  String get chatTitle;

  /// No description provided for @chatClearTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get chatClearTooltip;

  /// No description provided for @chatDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get chatDismiss;

  /// No description provided for @chatHint.
  ///
  /// In en, this message translates to:
  /// **'Message the backend AI…'**
  String get chatHint;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat history'**
  String get historyTitle;

  /// No description provided for @historyTitleDetail.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get historyTitleDetail;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved conversations yet.'**
  String get historyEmpty;

  /// No description provided for @historyMessageCount.
  ///
  /// In en, this message translates to:
  /// **'{count} messages'**
  String historyMessageCount(int count);

  /// No description provided for @historyDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete conversation'**
  String get historyDeleteTooltip;

  /// No description provided for @securityScansTitle.
  ///
  /// In en, this message translates to:
  /// **'Security scans'**
  String get securityScansTitle;

  /// No description provided for @scanNoteAndroidAuto.
  ///
  /// In en, this message translates to:
  /// **'Android automatic agent is on: the backend also receives periodic `/agent/auto-tick` with source=auto.'**
  String get scanNoteAndroidAuto;

  /// No description provided for @scanNoteManual.
  ///
  /// In en, this message translates to:
  /// **'All scans from this screen use source=manual (required on iOS).'**
  String get scanNoteManual;

  /// No description provided for @scanManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual security scan'**
  String get scanManualTitle;

  /// No description provided for @scanLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Link URL'**
  String get scanLinkLabel;

  /// No description provided for @scanLinkHint.
  ///
  /// In en, this message translates to:
  /// **'https://example.com/login'**
  String get scanLinkHint;

  /// No description provided for @scanScanLink.
  ///
  /// In en, this message translates to:
  /// **'Scan link'**
  String get scanScanLink;

  /// No description provided for @scanImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Image name'**
  String get scanImageLabel;

  /// No description provided for @scanImageHint.
  ///
  /// In en, this message translates to:
  /// **'suspected_generated_image.png'**
  String get scanImageHint;

  /// No description provided for @scanScanImage.
  ///
  /// In en, this message translates to:
  /// **'Scan image'**
  String get scanScanImage;

  /// No description provided for @scanErrorUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter a URL first.'**
  String get scanErrorUrl;

  /// No description provided for @scanErrorImage.
  ///
  /// In en, this message translates to:
  /// **'Enter an image file name first.'**
  String get scanErrorImage;

  /// No description provided for @scanType.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String scanType(Object type);

  /// No description provided for @scanSource.
  ///
  /// In en, this message translates to:
  /// **'Source: {source}'**
  String scanSource(Object source);

  /// No description provided for @scanLabelLine.
  ///
  /// In en, this message translates to:
  /// **'Label: {label}'**
  String scanLabelLine(Object label);

  /// No description provided for @scanScore.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String scanScore(Object score);

  /// No description provided for @scanReason.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String scanReason(Object reason);

  /// No description provided for @historyTabChat.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get historyTabChat;

  /// No description provided for @historyTabScans.
  ///
  /// In en, this message translates to:
  /// **'Scan log'**
  String get historyTabScans;

  /// No description provided for @scanHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No scans in your log yet. Use Link or Image to run a scan — results appear here while “Save scan history” is on (it’s on by default).'**
  String get scanHistoryEmpty;

  /// No description provided for @scanHistoryClear.
  ///
  /// In en, this message translates to:
  /// **'Clear scan log'**
  String get scanHistoryClear;

  /// No description provided for @riskLevel.
  ///
  /// In en, this message translates to:
  /// **'Risk: {level}'**
  String riskLevel(Object level);

  /// No description provided for @riskSummary.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get riskSummary;

  /// No description provided for @shareReport.
  ///
  /// In en, this message translates to:
  /// **'Share report'**
  String get shareReport;

  /// No description provided for @copyReport.
  ///
  /// In en, this message translates to:
  /// **'Copy report'**
  String get copyReport;

  /// No description provided for @reportCopied.
  ///
  /// In en, this message translates to:
  /// **'Report copied'**
  String get reportCopied;

  /// No description provided for @scanOpenLinkInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open link'**
  String get scanOpenLinkInBrowser;

  /// No description provided for @scanCopyLinkAddress.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get scanCopyLinkAddress;

  /// No description provided for @scanOpenLinkDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Open in browser?'**
  String get scanOpenLinkDialogTitle;

  /// No description provided for @scanOpenLinkDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This link was flagged or analyzed in the app only. Opening it in an external browser can still be risky (phishing, malware, or scams). Continue only if you understand the risk.'**
  String get scanOpenLinkDialogBody;

  /// No description provided for @scanOpenLinkDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get scanOpenLinkDialogCancel;

  /// No description provided for @scanOpenLinkDialogOpen.
  ///
  /// In en, this message translates to:
  /// **'Open anyway'**
  String get scanOpenLinkDialogOpen;

  /// No description provided for @scanCouldNotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Could not open this link on the device.'**
  String get scanCouldNotOpenLink;

  /// No description provided for @scanUrlCopiedWithWarning.
  ///
  /// In en, this message translates to:
  /// **'Link copied. Do not open it unless you trust it — it may still be dangerous.'**
  String get scanUrlCopiedWithWarning;

  /// No description provided for @pickGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get pickGallery;

  /// No description provided for @pickCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get pickCamera;

  /// No description provided for @scanUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Scan uploaded image'**
  String get scanUploadImage;

  /// No description provided for @typingIndicator.
  ///
  /// In en, this message translates to:
  /// **'Assistant is typing…'**
  String get typingIndicator;

  /// No description provided for @regenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get regenerate;

  /// No description provided for @copyMessage.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyMessage;

  /// No description provided for @messageCopied.
  ///
  /// In en, this message translates to:
  /// **'Message copied'**
  String get messageCopied;

  /// No description provided for @highRiskTitle.
  ///
  /// In en, this message translates to:
  /// **'Possible phishing or risky link'**
  String get highRiskTitle;

  /// No description provided for @highRiskBody.
  ///
  /// In en, this message translates to:
  /// **'We flagged content from your clipboard. Open the app to review.'**
  String get highRiskBody;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Email or username'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordHint;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubmit;

  /// No description provided for @loginGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginGoogle;

  /// No description provided for @loginApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get loginApple;

  /// No description provided for @loginGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue without account'**
  String get loginGuest;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed'**
  String get loginError;

  /// No description provided for @loginErrorEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or username.'**
  String get loginErrorEnterEmail;

  /// No description provided for @loginErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'That doesn’t look like a valid email address.'**
  String get loginErrorInvalidEmail;

  /// No description provided for @loginErrorAccountNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found for this email. Check the address or sign up.'**
  String get loginErrorAccountNotFound;

  /// No description provided for @loginErrorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password. Try again or reset your password.'**
  String get loginErrorWrongPassword;

  /// No description provided for @loginShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get loginShowPassword;

  /// No description provided for @loginHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get loginHidePassword;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logout;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsSaveChatHistory.
  ///
  /// In en, this message translates to:
  /// **'Save AI chat history on device'**
  String get settingsSaveChatHistory;

  /// No description provided for @settingsSaveChatHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Off by default. Chats stay in memory only unless you enable this.'**
  String get settingsSaveChatHistorySubtitle;

  /// No description provided for @settingsSaveScanHistory.
  ///
  /// In en, this message translates to:
  /// **'Save scan results on device'**
  String get settingsSaveScanHistory;

  /// No description provided for @settingsSaveScanHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stores links and images you scanned with risk summaries. On by default; turn off to stop adding new scans to the log.'**
  String get settingsSaveScanHistorySubtitle;

  /// No description provided for @settingsAboutPrivacySection.
  ///
  /// In en, this message translates to:
  /// **'About & privacy'**
  String get settingsAboutPrivacySection;

  /// No description provided for @settingsAboutAppShort.
  ///
  /// In en, this message translates to:
  /// **'Agent Ab helps you check suspicious links and images using your configured backend. Scans and optional chat may be sent to your server — see your deployment’s policy.'**
  String get settingsAboutAppShort;

  /// No description provided for @settingsPrivacyShort.
  ///
  /// In en, this message translates to:
  /// **'We don’t operate a central cloud for this template: data goes to the backend URL you set. Enable or disable saving chat/scan history on this device in the switches above.'**
  String get settingsPrivacyShort;

  /// No description provided for @settingsOpenPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Open full privacy policy'**
  String get settingsOpenPrivacyPolicy;

  /// No description provided for @settingsAutoAgentSubtitleAndroid.
  ///
  /// In en, this message translates to:
  /// **'Foreground only while the app is open: periodic check-in with the server, optional clipboard scan when you return to the app, and a local alert if something looks like phishing. Does not monitor other apps in the background. iOS stays manual only.'**
  String get settingsAutoAgentSubtitleAndroid;

  /// No description provided for @scanFromClipboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Clipboard link scanned'**
  String get scanFromClipboardTitle;

  /// No description provided for @scanFromClipboardDismiss.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get scanFromClipboardDismiss;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
