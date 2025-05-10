import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get chosenLanguage => 'ar';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get languageUpdated => 'تم تحديث اللغة بنجاح';

  @override
  String get next => 'التالي';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get voiceSettings => 'إعدادات الصوت';

  @override
  String get languageSettings => 'إعدادات اللغة';

  @override
  String get home => 'الرئيسية';

  @override
  String get wordBank => 'قاعدة الكلمات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get history => 'التاريخ';

  @override
  String get welcomeMessage => 'مرحباً';

  @override
  String get voiceYourMind => 'عبّر عن أفكارك بسهولة';

  @override
  String get startSpeakingNow => 'ابدأ التحدث الآن';

  @override
  String get helpAndGuide => 'المساعدة والدليل';

  @override
  String get rateApp => 'قيم التطبيق';

  @override
  String get rateMessage => 'يرجى تقييم تطبيقنا عن طريق اختيار النجوم!';

  @override
  String get submit => 'إرسال';

  @override
  String get later => 'لاحقًا';

  @override
  String get categories => 'فئات';

  @override
  String get searchForCategories => 'البحث عن الفئات...';

  @override
  String get processing => 'جارٍ المعالجة';

  @override
  String get processingSubtitle => 'جارٍ قراءة وتحليل بيانات الإشارة الخاصة بك';

  @override
  String get startThinking => 'ابدأ التفكير';

  @override
  String get doneThinking => 'انتهيت من التفكير';

  @override
  String get moveToNextWord => 'انتقل إلى الكلمة التالية';

  @override
  String get restart => 'إعادة البدء';

  @override
  String get noCategoriesFound => 'لم يتم العثور على فئات';

  @override
  String get connectToHeadset => 'اتصل بسماعة الرأس';

  @override
  String get syncInstructions => 'قم بتوصيل التطبيق مع سماعة الرأس لبدء التعبير عن أفكارك';

  @override
  String get scanning => 'جارٍ البحث...';

  @override
  String get noHeadsetsFound => 'لم يتم العثور على سماعات رأس';

  @override
  String headsetsFound(Object count) {
    return 'تم العثور على $count سماعة/سماعات';
  }

  @override
  String get connect => 'اتصال';
}
