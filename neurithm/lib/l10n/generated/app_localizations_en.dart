import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get chosenLanguage => 'en';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get languageUpdated => 'Language updated successfully';

  @override
  String get next => 'Next';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get voiceSettings => 'Voice Settings';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get home => 'Home';

  @override
  String get wordBank => 'Word Bank';

  @override
  String get settings => 'Settings';

  @override
  String get history => 'History';

  @override
  String get welcomeMessage => 'Welcome';

  @override
  String get voiceYourMind => 'Voice Your Mind Effortlessly';

  @override
  String get startSpeakingNow => 'Start Speaking Now';

  @override
  String get helpAndGuide => 'Help & Guide';

  @override
  String get rateApp => 'Rate App';

  @override
  String get rateMessage => 'Please rate our app by selecting stars!';

  @override
  String get submit => 'Submit';

  @override
  String get later => 'Later';

  @override
  String get categories => 'Categories';

  @override
  String get searchForCategories => 'Search categories...';

  @override
  String get processing => 'Processing';

  @override
  String get processingSubtitle => 'Reading and analyzing your signal data';

  @override
  String get startThinking => 'Start Thinking';

  @override
  String get doneThinking => 'Done Thinking';

  @override
  String get moveToNextWord => 'Move to Next Word';

  @override
  String get restart => 'Restart';

  @override
  String get noCategoriesFound => 'No categories found';

  @override
  String get connectToHeadset => 'Connect to a Headset';

  @override
  String get syncInstructions => 'Sync your mobile app to your headset to start voicing your thoughts';

  @override
  String get scanning => 'Scanning...';

  @override
  String get noHeadsetsFound => 'No headsets found';

  @override
  String headsetsFound(Object count) {
    return '$count headset(s) found';
  }

  @override
  String get connect => 'Connect';
}
