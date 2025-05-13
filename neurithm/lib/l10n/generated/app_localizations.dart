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
/// import 'generated/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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

  /// No description provided for @chosenLanguage.
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get chosenLanguage;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @languageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Language updated successfully'**
  String get languageUpdated;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @voiceSettings.
  ///
  /// In en, this message translates to:
  /// **'Voice Settings'**
  String get voiceSettings;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @wordBank.
  ///
  /// In en, this message translates to:
  /// **'Word Bank'**
  String get wordBank;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeMessage;

  /// No description provided for @voiceYourMind.
  ///
  /// In en, this message translates to:
  /// **'Voice Your Mind Effortlessly'**
  String get voiceYourMind;

  /// No description provided for @startSpeakingNow.
  ///
  /// In en, this message translates to:
  /// **'Start Speaking Now'**
  String get startSpeakingNow;

  /// No description provided for @helpAndGuide.
  ///
  /// In en, this message translates to:
  /// **'Help & Guide'**
  String get helpAndGuide;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @rateMessage.
  ///
  /// In en, this message translates to:
  /// **'Please rate our app by selecting stars!'**
  String get rateMessage;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @searchForCategories.
  ///
  /// In en, this message translates to:
  /// **'Search categories...'**
  String get searchForCategories;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @processingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reading and analyzing your signal data'**
  String get processingSubtitle;

  /// No description provided for @startThinking.
  ///
  /// In en, this message translates to:
  /// **'Start Thinking'**
  String get startThinking;

  /// No description provided for @doneThinking.
  ///
  /// In en, this message translates to:
  /// **'Done Thinking'**
  String get doneThinking;

  /// No description provided for @moveToNextWord.
  ///
  /// In en, this message translates to:
  /// **'Move to Next Word'**
  String get moveToNextWord;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get noCategoriesFound;

  /// No description provided for @connectToHeadset.
  ///
  /// In en, this message translates to:
  /// **'Connect to a Headset'**
  String get connectToHeadset;

  /// No description provided for @syncInstructions.
  ///
  /// In en, this message translates to:
  /// **'Sync your mobile app to your headset to start voicing your thoughts'**
  String get syncInstructions;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @noHeadsetsFound.
  ///
  /// In en, this message translates to:
  /// **'No headsets found'**
  String get noHeadsetsFound;

  /// No description provided for @headsetsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} headset(s) found'**
  String headsetsFound(Object count);

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get about;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help and Support'**
  String get helpAndSupport;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get accountInfo;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutUs;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Redefining Means of Communication'**
  String get tagline;

  /// No description provided for @mission.
  ///
  /// In en, this message translates to:
  /// **'At Neurithm, we are committed to breaking barriers in communication for individuals with severe speech and movement disabilities. Our system harnesses the power of Brain-Computer Interface (BCI) technology, artificial intelligence, and speech synthesis to transform neural activity into spoken language, empowering users with a new voice.'**
  String get mission;

  /// No description provided for @visionTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Vision'**
  String get visionTitle;

  /// No description provided for @vision.
  ///
  /// In en, this message translates to:
  /// **'To create a world where communication is limitless, regardless of physical ability. By merging cutting-edge neuroscience with technology, we aim to provide tools that restore independence and enhance human connection.'**
  String get vision;

  /// No description provided for @technologyTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Technology'**
  String get technologyTitle;

  /// No description provided for @technology.
  ///
  /// In en, this message translates to:
  /// **'• Non-Invasive BCI: Utilizing EEG headsets, our system captures and interprets brain activity without the need for invasive procedures.\n• Deep Learning Models: Multiple deep learning models were employed to decode neural signals into coherent speech in real time.\n• User-Centered Design: Designed with ease of use in mind, our system is accessible to individuals and caregivers alike.'**
  String get technology;

  /// No description provided for @whyItMattersTitle.
  ///
  /// In en, this message translates to:
  /// **'Why It Matters'**
  String get whyItMattersTitle;

  /// No description provided for @whyItMatters.
  ///
  /// In en, this message translates to:
  /// **'Millions of individuals worldwide live with conditions like ALS, locked-in syndrome, or severe paralysis. Our solution provides them with an avenue for expression, autonomy, and connection—one word at a time.'**
  String get whyItMatters;

  /// No description provided for @teamTitle.
  ///
  /// In en, this message translates to:
  /// **'Meet the Team'**
  String get teamTitle;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'We are a dedicated group of software engineers, neuroscientists, and innovators passionate about leveraging technology to improve lives. Our multidisciplinary expertise fuels our mission to make cutting-edge solutions accessible to those who need them most.'**
  String get team;

  /// No description provided for @acknowledgmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Acknowledgments'**
  String get acknowledgmentsTitle;

  /// No description provided for @acknowledgments.
  ///
  /// In en, this message translates to:
  /// **'We extend our gratitude to our university for their unwavering support and resources, enabling us to bring this project to life.'**
  String get acknowledgments;

  /// No description provided for @getInvolvedTitle.
  ///
  /// In en, this message translates to:
  /// **'Get Involved'**
  String get getInvolvedTitle;

  /// No description provided for @getInvolved.
  ///
  /// In en, this message translates to:
  /// **'We are continuously looking for collaborators, researchers, and users to shape the future of this technology. Contact us to join the journey!'**
  String get getInvolved;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpTitle;

  /// No description provided for @helpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Facing any issues? Submit the form below and we’ll get back to you via email as soon as possible.'**
  String get helpSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get passwordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @commentLabel.
  ///
  /// In en, this message translates to:
  /// **'Comment or Message'**
  String get commentLabel;

  /// No description provided for @submitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitButton;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faqTitle;

  /// No description provided for @goToTutorial.
  ///
  /// In en, this message translates to:
  /// **'Go to Tutorial'**
  String get goToTutorial;

  /// No description provided for @emptyCommentError.
  ///
  /// In en, this message translates to:
  /// **'Comment/Message cannot be empty'**
  String get emptyCommentError;

  /// No description provided for @submitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Comment submitted successfully.'**
  String get submitSuccess;

  /// No description provided for @submitFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit feedback.'**
  String get submitFailure;

  /// No description provided for @faq1Question.
  ///
  /// In en, this message translates to:
  /// **'How do I use this app?'**
  String get faq1Question;

  /// No description provided for @faq1Answer.
  ///
  /// In en, this message translates to:
  /// **'To use the app, navigate through the menu and select the desired feature (translate thoughts, access word bank, user profile). Detailed tutorials are available in the tutorial section.'**
  String get faq1Answer;

  /// No description provided for @faq2Question.
  ///
  /// In en, this message translates to:
  /// **'How can I contact support?'**
  String get faq2Question;

  /// No description provided for @faq2Answer.
  ///
  /// In en, this message translates to:
  /// **'You can contact support through the submitting the form above this section or email us at neurithm1@gmail.com.'**
  String get faq2Answer;

  /// No description provided for @faq3Question.
  ///
  /// In en, this message translates to:
  /// **'Where can I find my history?'**
  String get faq3Question;

  /// No description provided for @faq3Answer.
  ///
  /// In en, this message translates to:
  /// **'Saved data can be found in the \"History\" section accessible from the bottom bar.'**
  String get faq3Answer;

  /// No description provided for @voiceOptions.
  ///
  /// In en, this message translates to:
  /// **'Voice Options'**
  String get voiceOptions;

  /// No description provided for @pitch.
  ///
  /// In en, this message translates to:
  /// **'Pitch'**
  String get pitch;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @testVoice.
  ///
  /// In en, this message translates to:
  /// **'Test Voice'**
  String get testVoice;

  /// No description provided for @textToSpeakLabel.
  ///
  /// In en, this message translates to:
  /// **'Text to speak'**
  String get textToSpeakLabel;

  /// No description provided for @textToSpeakHint.
  ///
  /// In en, this message translates to:
  /// **'Enter text here...'**
  String get textToSpeakHint;

  /// No description provided for @playVoice.
  ///
  /// In en, this message translates to:
  /// **'Generate & Play Voice'**
  String get playVoice;

  /// No description provided for @playing.
  ///
  /// In en, this message translates to:
  /// **'Playing..'**
  String get playing;

  /// No description provided for @replay.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get replay;

  /// No description provided for @enterTextWarning.
  ///
  /// In en, this message translates to:
  /// **'Please enter some text to generate speech.'**
  String get enterTextWarning;

  /// No description provided for @preferencesSaved.
  ///
  /// In en, this message translates to:
  /// **'Your preferences have been saved successfully.'**
  String get preferencesSaved;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @chooseCorrectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Preferred\nCorrection'**
  String get chooseCorrectionLabel;

  /// No description provided for @regenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get regenerate;

  /// No description provided for @recite.
  ///
  /// In en, this message translates to:
  /// **'Recite'**
  String get recite;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @reciteThoughtLabel.
  ///
  /// In en, this message translates to:
  /// **'Reciting Your Thought'**
  String get reciteThoughtLabel;

  /// No description provided for @returnToThinking.
  ///
  /// In en, this message translates to:
  /// **'Return to Thinking'**
  String get returnToThinking;

  /// No description provided for @reciteAgain.
  ///
  /// In en, this message translates to:
  /// **'Recite Again'**
  String get reciteAgain;

  /// No description provided for @sessionFeedback.
  ///
  /// In en, this message translates to:
  /// **'Session Feedback'**
  String get sessionFeedback;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @conversationHistory.
  ///
  /// In en, this message translates to:
  /// **'Conversation History'**
  String get conversationHistory;

  /// No description provided for @noConversationsFound.
  ///
  /// In en, this message translates to:
  /// **'No conversations found'**
  String get noConversationsFound;

  /// No description provided for @sessionDate.
  ///
  /// In en, this message translates to:
  /// **'Session Date'**
  String get sessionDate;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this session?'**
  String get confirmDelete;

  /// No description provided for @step1.
  ///
  /// In en, this message translates to:
  /// **'Get your headset (Emotiv Epoc X) out of its package.'**
  String get step1;

  /// No description provided for @step2.
  ///
  /// In en, this message translates to:
  /// **'Hydrate the sensor felts using saline solution. Do not use contact lens cleaning or sterilizing solutions.'**
  String get step2;

  /// No description provided for @step3.
  ///
  /// In en, this message translates to:
  /// **'Place the sensor felts in a glass, add saline solution, and soak. Squeeze out excess fluid before inserting them into the sensors.'**
  String get step3;

  /// No description provided for @step4.
  ///
  /// In en, this message translates to:
  /// **'To rehydrate sensors while using the headset, add saline solution through the top opening of each sensor.'**
  String get step4;

  /// No description provided for @step5.
  ///
  /// In en, this message translates to:
  /// **'Insert the sensor felts into each sensor opening and press the power button to turn on the headset. A white LED will illuminate, and the headset will beep. To optimize the use of your headset, we recommend that you fully charge it before making recordings.'**
  String get step5;

  /// No description provided for @step6.
  ///
  /// In en, this message translates to:
  /// **'Turn on Bluetooth on your phone and navigate to the \"Connect to Headset\" page.'**
  String get step6;

  /// No description provided for @step7.
  ///
  /// In en, this message translates to:
  /// **'Click the big circular button to scan for devices and select the headset when it appears.'**
  String get step7;

  /// No description provided for @step8.
  ///
  /// In en, this message translates to:
  /// **'Once connected, you can start the thought translation process!'**
  String get step8;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
