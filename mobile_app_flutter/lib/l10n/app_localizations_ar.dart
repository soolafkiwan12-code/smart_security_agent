// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'وكيل أب';

  @override
  String get navAgent => 'الوكيل الذكي';

  @override
  String get navHistory => 'السجل';

  @override
  String get navScans => 'الفحوصات';

  @override
  String get navScanLink => 'رابط';

  @override
  String get navScanImage => 'صورة';

  @override
  String get scanLinkScreenTitle => 'فحص الرابط';

  @override
  String get scanLinkScreenSubtitle => 'تحليل الروابط المشبوهة فورًا';

  @override
  String get scanSuspiciousUrlLabel => 'رابط مشبوه';

  @override
  String get scanLinkAction => 'فحص';

  @override
  String get scanAnalyzingLink => 'جاري تحليل الرابط…';

  @override
  String get scanImageScreenTitle => 'فحص الصورة';

  @override
  String get scanImageScreenSubtitle =>
      'تحقق ما إذا كانت الصورة منشأة بالذكاء الاصطناعي';

  @override
  String get scanChooseImageOrCamera => 'اختر صورة أو الكاميرا';

  @override
  String get scanNoFileChosen => 'لم يُختَر ملف';

  @override
  String get scanAnalyzeAction => 'تحليل';

  @override
  String get scanAnalyzingImage => 'جاري تحليل الصورة…';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsLanguageSubtitle => 'التبديل بين الإنجليزية والعربية';

  @override
  String get settingsTheme => 'الثيم';

  @override
  String get settingsThemeSubtitle => 'وضع فاتح أو داكن أو مطابقة الجهاز';

  @override
  String get langEnglish => 'الإنجليزية';

  @override
  String get langArabic => 'العربية';

  @override
  String get themeSystem => 'حسب النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get settingsFontSize => 'حجم الخط';

  @override
  String get settingsFontSizeSubtitle => 'تكبير أو تصغير النص في التطبيق';

  @override
  String get fontSizeCompact => 'صغير';

  @override
  String get fontSizeStandard => 'افتراضي';

  @override
  String get fontSizeComfortable => 'مريح';

  @override
  String get settingsBackend => 'الخادم';

  @override
  String get settingsBaseUrl => 'عنوان الخادم';

  @override
  String get settingsBaseUrlHint => 'http://10.0.2.2:5000';

  @override
  String get settingsSaveUrl => 'حفظ العنوان';

  @override
  String get settingsHealthCheck => 'GET /health';

  @override
  String get settingsUrlSaved => 'تم حفظ عنوان الخادم.';

  @override
  String get settingsAgentMode => 'وضع الوكيل';

  @override
  String get settingsAutoAgentTitle => 'وكيل تلقائي (أندرويد)';

  @override
  String get settingsAutoAgentSubtitle =>
      'يرسل بشكل دوري طلب POST /agent/auto-tick مع source=auto أثناء تشغيل التطبيق.';

  @override
  String get settingsManualOnlyTitle => 'يدوي فقط (iOS)';

  @override
  String get settingsManualOnlySubtitle =>
      'نسخ iOS لا تفعّل نبضات الوكيل التلقائي في الخلفية في هذا القالب.';

  @override
  String get settingsCopyUrl => 'نسخ العنوان النهائي';

  @override
  String get settingsCopied => 'تم نسخ عنوان الخادم';

  @override
  String get healthOkEmpty => 'تمام (الجسم فارغ)';

  @override
  String get chatTitle => 'وكيل أب · الذكاء الاصطناعي';

  @override
  String get chatClearTooltip => 'مسح المحادثة';

  @override
  String get chatDismiss => 'إخفاء';

  @override
  String get chatHint => 'اكتب رسالة للذكاء الاصطناعي على الخادم…';

  @override
  String get historyTitle => 'سجل المحادثات';

  @override
  String get historyTitleDetail => 'محادثة';

  @override
  String get historyEmpty => 'لا توجد محادثات محفوظة بعد.';

  @override
  String historyMessageCount(int count) {
    return '$count رسالة';
  }

  @override
  String get historyDeleteTooltip => 'حذف المحادثة';

  @override
  String get securityScansTitle => 'فحوصات الأمان';

  @override
  String get scanNoteAndroidAuto =>
      'وضع الوكيل التلقائي مفعّل على أندرويد: الخادم يستقبل أيضًا طلبات `/agent/auto-tick` دورية مع source=auto.';

  @override
  String get scanNoteManual =>
      'كل الفحوصات من هذه الشاشة تستخدم source=manual (مطلوب على iOS).';

  @override
  String get scanManualTitle => 'فحص أمان يدوي';

  @override
  String get scanLinkLabel => 'رابط URL';

  @override
  String get scanLinkHint => 'https://example.com/login';

  @override
  String get scanScanLink => 'فحص الرابط';

  @override
  String get scanImageLabel => 'اسم الصورة';

  @override
  String get scanImageHint => 'suspected_generated_image.png';

  @override
  String get scanScanImage => 'فحص الصورة';

  @override
  String get scanErrorUrl => 'أدخل الرابط أولاً.';

  @override
  String get scanErrorImage => 'أدخل اسم ملف الصورة أولاً.';

  @override
  String scanType(Object type) {
    return 'النوع: $type';
  }

  @override
  String scanSource(Object source) {
    return 'المصدر: $source';
  }

  @override
  String scanLabelLine(Object label) {
    return 'التصنيف: $label';
  }

  @override
  String scanScore(Object score) {
    return 'الدرجة: $score';
  }

  @override
  String scanReason(Object reason) {
    return 'السبب: $reason';
  }

  @override
  String get historyTabChat => 'المحادثات';

  @override
  String get historyTabScans => 'سجل الفحوصات';

  @override
  String get scanHistoryEmpty =>
      'لا يوجد شيء في السجل بعد. استخدم «رابط» أو «صورة» للفحص — تظهر النتائج هنا طالما «حفظ سجل الفحوصات» مفعّل (مفعّل افتراضياً).';

  @override
  String get scanHistoryClear => 'مسح سجل الفحوصات';

  @override
  String riskLevel(Object level) {
    return 'المخاطر: $level';
  }

  @override
  String get riskSummary => 'التقييم';

  @override
  String get shareReport => 'مشاركة التقرير';

  @override
  String get copyReport => 'نسخ التقرير';

  @override
  String get reportCopied => 'تم نسخ التقرير';

  @override
  String get scanOpenLinkInBrowser => 'فتح الرابط';

  @override
  String get scanCopyLinkAddress => 'نسخ الرابط';

  @override
  String get scanOpenLinkDialogTitle => 'فتح في المتصفح؟';

  @override
  String get scanOpenLinkDialogBody =>
      'تم تحليل هذا الرابط داخل التطبيق فقط. فتحه في متصفح خارجي قد يبقى خطيراً (تصيّد، برمجيات خبيثة، أو احتيال). تابع فقط إذا تفهم المخاطرة.';

  @override
  String get scanOpenLinkDialogCancel => 'إلغاء';

  @override
  String get scanOpenLinkDialogOpen => 'فتح على أي حال';

  @override
  String get scanCouldNotOpenLink => 'تعذّر فتح الرابط على هذا الجهاز.';

  @override
  String get scanUrlCopiedWithWarning =>
      'تم نسخ الرابط. لا تفتحه إلا إذا وثقت به — قد يبقى خطيراً.';

  @override
  String get pickGallery => 'المعرض';

  @override
  String get pickCamera => 'الكاميرا';

  @override
  String get scanUploadImage => 'فحص صورة مرفوعة';

  @override
  String get typingIndicator => 'الوكيل يكتب…';

  @override
  String get regenerate => 'إعادة توليد';

  @override
  String get copyMessage => 'نسخ';

  @override
  String get messageCopied => 'تم نسخ الرسالة';

  @override
  String get highRiskTitle => 'احتمال تصيّد أو رابط خطير';

  @override
  String get highRiskBody => 'تم رصد محتوى من الحافظة. افتح التطبيق للمراجعة.';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginEmailHint => 'البريد أو اسم المستخدم';

  @override
  String get loginPasswordHint => 'كلمة المرور';

  @override
  String get loginSubmit => 'دخول';

  @override
  String get loginGoogle => 'المتابعة مع Google';

  @override
  String get loginApple => 'المتابعة مع Apple';

  @override
  String get loginGuest => 'متابعة بدون حساب';

  @override
  String get loginError => 'فشل تسجيل الدخول';

  @override
  String get loginErrorEnterEmail => 'أدخل البريد أو اسم المستخدم.';

  @override
  String get loginErrorInvalidEmail => 'صيغة البريد غير صحيحة.';

  @override
  String get loginErrorAccountNotFound =>
      'لا يوجد حساب بهذا البريد. تحقق من العنوان أو أنشئ حساباً.';

  @override
  String get loginErrorWrongPassword =>
      'كلمة المرور غير صحيحة. حاول مرة أخرى أو أعد التعيين.';

  @override
  String get loginShowPassword => 'إظهار كلمة المرور';

  @override
  String get loginHidePassword => 'إخفاء كلمة المرور';

  @override
  String get logout => 'خروج';

  @override
  String get settingsPrivacy => 'الخصوصية';

  @override
  String get settingsSaveChatHistory =>
      'حفظ محادثات الذكاء الاصطناعي على الجهاز';

  @override
  String get settingsSaveChatHistorySubtitle =>
      'افتراضياً لا يُحفظ شيء. المحادثات تبقى في الذاكرة فقط إلا إذا فعّلت الخيار.';

  @override
  String get settingsSaveScanHistory => 'حفظ نتائج الفحص على الجهاز';

  @override
  String get settingsSaveScanHistorySubtitle =>
      'يخزن الروابط والصور التي فحصتها مع ملخص المخاطر. مفعّل افتراضياً؛ عطّله لإيقاف إضافة فحوصات جديدة للسجل.';

  @override
  String get settingsAboutPrivacySection => 'عن التطبيق والخصوصية';

  @override
  String get settingsAboutAppShort =>
      '«وكيل أب» يساعدك على فحص الروابط والصور المشبوهة عبر الخادم الذي تضبطه. قد تُرسل عمليات الفحص والدردشة الاختيارية إلى خادمك — راجع سياسة النشر لديك.';

  @override
  String get settingsPrivacyShort =>
      'هذا القالب لا يعتمد سحابة مركزية منّا: البيانات تذهب لعنوان الخادم الذي تضبطه. يمكنك تفعيل أو إيقاف حفظ المحادثة/سجل الفحص على الجهاز من الأعلى.';

  @override
  String get settingsOpenPrivacyPolicy => 'فتح سياسة الخصوصية الكاملة';

  @override
  String get settingsAutoAgentSubtitleAndroid =>
      'يعمل مع فتح التطبيق فقط: تحقق دوري من الخادم، واختياريًا فحص الحافظة عند العودة للتطبيق، وتنبيه محلي عند احتمال تصيّد. لا يراقب تطبيقات أخرى في الخلفية. iOS يبقى يدوياً فقط.';

  @override
  String get scanFromClipboardTitle => 'تم فحص رابط من الحافظة';

  @override
  String get scanFromClipboardDismiss => 'حسناً';
}
