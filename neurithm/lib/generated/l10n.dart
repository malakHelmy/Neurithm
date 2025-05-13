// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get chosenLanguage {
    return Intl.message('en', name: 'chosenLanguage', desc: '', args: []);
  }

  /// `Choose Language`
  String get chooseLanguage {
    return Intl.message(
      'Choose Language',
      name: 'chooseLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Language updated successfully`
  String get languageUpdated {
    return Intl.message(
      'Language updated successfully',
      name: 'languageUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Account Settings`
  String get accountSettings {
    return Intl.message(
      'Account Settings',
      name: 'accountSettings',
      desc: '',
      args: [],
    );
  }

  /// `Voice Settings`
  String get voiceSettings {
    return Intl.message(
      'Voice Settings',
      name: 'voiceSettings',
      desc: '',
      args: [],
    );
  }

  /// `Language Settings`
  String get languageSettings {
    return Intl.message(
      'Language Settings',
      name: 'languageSettings',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Word Bank`
  String get wordBank {
    return Intl.message('Word Bank', name: 'wordBank', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Welcome`
  String get welcomeMessage {
    return Intl.message('Welcome', name: 'welcomeMessage', desc: '', args: []);
  }

  /// `Voice Your Mind Effortlessly`
  String get voiceYourMind {
    return Intl.message(
      'Voice Your Mind Effortlessly',
      name: 'voiceYourMind',
      desc: '',
      args: [],
    );
  }

  /// `Start Speaking Now`
  String get startSpeakingNow {
    return Intl.message(
      'Start Speaking Now',
      name: 'startSpeakingNow',
      desc: '',
      args: [],
    );
  }

  /// `Help & Guide`
  String get helpAndGuide {
    return Intl.message(
      'Help & Guide',
      name: 'helpAndGuide',
      desc: '',
      args: [],
    );
  }

  /// `Rate App`
  String get rateApp {
    return Intl.message('Rate App', name: 'rateApp', desc: '', args: []);
  }

  /// `Please rate our app by selecting stars!`
  String get rateMessage {
    return Intl.message(
      'Please rate our app by selecting stars!',
      name: 'rateMessage',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Later`
  String get later {
    return Intl.message('Later', name: 'later', desc: '', args: []);
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Search categories...`
  String get searchForCategories {
    return Intl.message(
      'Search categories...',
      name: 'searchForCategories',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get processing {
    return Intl.message('Processing', name: 'processing', desc: '', args: []);
  }

  /// `Reading and analyzing your signal data`
  String get processingSubtitle {
    return Intl.message(
      'Reading and analyzing your signal data',
      name: 'processingSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Start Thinking`
  String get startThinking {
    return Intl.message(
      'Start Thinking',
      name: 'startThinking',
      desc: '',
      args: [],
    );
  }

  /// `Done Thinking`
  String get doneThinking {
    return Intl.message(
      'Done Thinking',
      name: 'doneThinking',
      desc: '',
      args: [],
    );
  }

  /// `Move to Next Word`
  String get moveToNextWord {
    return Intl.message(
      'Move to Next Word',
      name: 'moveToNextWord',
      desc: '',
      args: [],
    );
  }

  /// `Restart`
  String get restart {
    return Intl.message('Restart', name: 'restart', desc: '', args: []);
  }

  /// `No categories found`
  String get noCategoriesFound {
    return Intl.message(
      'No categories found',
      name: 'noCategoriesFound',
      desc: '',
      args: [],
    );
  }

  /// `Connect to a Headset`
  String get connectToHeadset {
    return Intl.message(
      'Connect to a Headset',
      name: 'connectToHeadset',
      desc: '',
      args: [],
    );
  }

  /// `Sync your mobile app to your headset to start voicing your thoughts`
  String get syncInstructions {
    return Intl.message(
      'Sync your mobile app to your headset to start voicing your thoughts',
      name: 'syncInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Scanning...`
  String get scanning {
    return Intl.message('Scanning...', name: 'scanning', desc: '', args: []);
  }

  /// `No headsets found`
  String get noHeadsetsFound {
    return Intl.message(
      'No headsets found',
      name: 'noHeadsetsFound',
      desc: '',
      args: [],
    );
  }

  /// `{count} headset(s) found`
  String headsetsFound(Object count) {
    return Intl.message(
      '$count headset(s) found',
      name: 'headsetsFound',
      desc: '',
      args: [count],
    );
  }

  /// `Connect`
  String get connect {
    return Intl.message('Connect', name: 'connect', desc: '', args: []);
  }

  /// `About us`
  String get about {
    return Intl.message('About us', name: 'about', desc: '', args: []);
  }

  /// `Help and Support`
  String get helpAndSupport {
    return Intl.message(
      'Help and Support',
      name: 'helpAndSupport',
      desc: '',
      args: [],
    );
  }

  /// `Account Info`
  String get accountInfo {
    return Intl.message(
      'Account Info',
      name: 'accountInfo',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message('Log out', name: 'logOut', desc: '', args: []);
  }

  /// `About us`
  String get aboutUs {
    return Intl.message('About us', name: 'aboutUs', desc: '', args: []);
  }

  /// `Redefining Means of Communication`
  String get tagline {
    return Intl.message(
      'Redefining Means of Communication',
      name: 'tagline',
      desc: '',
      args: [],
    );
  }

  /// `At Neurithm, we are committed to breaking barriers in communication for individuals with severe speech and movement disabilities. Our system harnesses the power of Brain-Computer Interface (BCI) technology, artificial intelligence, and speech synthesis to transform neural activity into spoken language, empowering users with a new voice.`
  String get mission {
    return Intl.message(
      'At Neurithm, we are committed to breaking barriers in communication for individuals with severe speech and movement disabilities. Our system harnesses the power of Brain-Computer Interface (BCI) technology, artificial intelligence, and speech synthesis to transform neural activity into spoken language, empowering users with a new voice.',
      name: 'mission',
      desc: '',
      args: [],
    );
  }

  /// `Our Vision`
  String get visionTitle {
    return Intl.message('Our Vision', name: 'visionTitle', desc: '', args: []);
  }

  /// `To create a world where communication is limitless, regardless of physical ability. By merging cutting-edge neuroscience with technology, we aim to provide tools that restore independence and enhance human connection.`
  String get vision {
    return Intl.message(
      'To create a world where communication is limitless, regardless of physical ability. By merging cutting-edge neuroscience with technology, we aim to provide tools that restore independence and enhance human connection.',
      name: 'vision',
      desc: '',
      args: [],
    );
  }

  /// `Our Technology`
  String get technologyTitle {
    return Intl.message(
      'Our Technology',
      name: 'technologyTitle',
      desc: '',
      args: [],
    );
  }

  /// `• Non-Invasive BCI: Utilizing EEG headsets, our system captures and interprets brain activity without the need for invasive procedures.\n• Deep Learning Models: Multiple deep learning models were employed to decode neural signals into coherent speech in real time.\n• User-Centered Design: Designed with ease of use in mind, our system is accessible to individuals and caregivers alike.`
  String get technology {
    return Intl.message(
      '• Non-Invasive BCI: Utilizing EEG headsets, our system captures and interprets brain activity without the need for invasive procedures.\n• Deep Learning Models: Multiple deep learning models were employed to decode neural signals into coherent speech in real time.\n• User-Centered Design: Designed with ease of use in mind, our system is accessible to individuals and caregivers alike.',
      name: 'technology',
      desc: '',
      args: [],
    );
  }

  /// `Why It Matters`
  String get whyItMattersTitle {
    return Intl.message(
      'Why It Matters',
      name: 'whyItMattersTitle',
      desc: '',
      args: [],
    );
  }

  /// `Millions of individuals worldwide live with conditions like ALS, locked-in syndrome, or severe paralysis. Our solution provides them with an avenue for expression, autonomy, and connection—one word at a time.`
  String get whyItMatters {
    return Intl.message(
      'Millions of individuals worldwide live with conditions like ALS, locked-in syndrome, or severe paralysis. Our solution provides them with an avenue for expression, autonomy, and connection—one word at a time.',
      name: 'whyItMatters',
      desc: '',
      args: [],
    );
  }

  /// `Meet the Team`
  String get teamTitle {
    return Intl.message('Meet the Team', name: 'teamTitle', desc: '', args: []);
  }

  /// `We are a dedicated group of software engineers, neuroscientists, and innovators passionate about leveraging technology to improve lives. Our multidisciplinary expertise fuels our mission to make cutting-edge solutions accessible to those who need them most.`
  String get team {
    return Intl.message(
      'We are a dedicated group of software engineers, neuroscientists, and innovators passionate about leveraging technology to improve lives. Our multidisciplinary expertise fuels our mission to make cutting-edge solutions accessible to those who need them most.',
      name: 'team',
      desc: '',
      args: [],
    );
  }

  /// `Acknowledgments`
  String get acknowledgmentsTitle {
    return Intl.message(
      'Acknowledgments',
      name: 'acknowledgmentsTitle',
      desc: '',
      args: [],
    );
  }

  /// `We extend our gratitude to our university for their unwavering support and resources, enabling us to bring this project to life.`
  String get acknowledgments {
    return Intl.message(
      'We extend our gratitude to our university for their unwavering support and resources, enabling us to bring this project to life.',
      name: 'acknowledgments',
      desc: '',
      args: [],
    );
  }

  /// `Get Involved`
  String get getInvolvedTitle {
    return Intl.message(
      'Get Involved',
      name: 'getInvolvedTitle',
      desc: '',
      args: [],
    );
  }

  /// `We are continuously looking for collaborators, researchers, and users to shape the future of this technology. Contact us to join the journey!`
  String get getInvolved {
    return Intl.message(
      'We are continuously looking for collaborators, researchers, and users to shape the future of this technology. Contact us to join the journey!',
      name: 'getInvolved',
      desc: '',
      args: [],
    );
  }

  /// `Help & Support`
  String get helpTitle {
    return Intl.message(
      'Help & Support',
      name: 'helpTitle',
      desc: '',
      args: [],
    );
  }

  /// `Facing any issues? Submit the form below and we’ll get back to you via email as soon as possible.`
  String get helpSubtitle {
    return Intl.message(
      'Facing any issues? Submit the form below and we’ll get back to you via email as soon as possible.',
      name: 'helpSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullNameLabel {
    return Intl.message('Full Name', name: 'fullNameLabel', desc: '', args: []);
  }

  /// `First Name`
  String get firstNameLabel {
    return Intl.message(
      'First Name',
      name: 'firstNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastNameLabel {
    return Intl.message('Last Name', name: 'lastNameLabel', desc: '', args: []);
  }

  /// `New Password`
  String get passwordLabel {
    return Intl.message(
      'New Password',
      name: 'passwordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPasswordLabel {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabel {
    return Intl.message('Email', name: 'emailLabel', desc: '', args: []);
  }

  /// `Comment or Message`
  String get commentLabel {
    return Intl.message(
      'Comment or Message',
      name: 'commentLabel',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submitButton {
    return Intl.message('Submit', name: 'submitButton', desc: '', args: []);
  }

  /// `Frequently Asked Questions`
  String get faqTitle {
    return Intl.message(
      'Frequently Asked Questions',
      name: 'faqTitle',
      desc: '',
      args: [],
    );
  }

  /// `Go to Tutorial`
  String get goToTutorial {
    return Intl.message(
      'Go to Tutorial',
      name: 'goToTutorial',
      desc: '',
      args: [],
    );
  }

  /// `Comment/Message cannot be empty`
  String get emptyCommentError {
    return Intl.message(
      'Comment/Message cannot be empty',
      name: 'emptyCommentError',
      desc: '',
      args: [],
    );
  }

  /// `Comment submitted successfully.`
  String get submitSuccess {
    return Intl.message(
      'Comment submitted successfully.',
      name: 'submitSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to submit feedback.`
  String get submitFailure {
    return Intl.message(
      'Failed to submit feedback.',
      name: 'submitFailure',
      desc: '',
      args: [],
    );
  }

  /// `How do I use this app?`
  String get faq1Question {
    return Intl.message(
      'How do I use this app?',
      name: 'faq1Question',
      desc: '',
      args: [],
    );
  }

  /// `To use the app, navigate through the menu and select the desired feature (translate thoughts, access word bank, user profile). Detailed tutorials are available in the tutorial section.`
  String get faq1Answer {
    return Intl.message(
      'To use the app, navigate through the menu and select the desired feature (translate thoughts, access word bank, user profile). Detailed tutorials are available in the tutorial section.',
      name: 'faq1Answer',
      desc: '',
      args: [],
    );
  }

  /// `How can I contact support?`
  String get faq2Question {
    return Intl.message(
      'How can I contact support?',
      name: 'faq2Question',
      desc: '',
      args: [],
    );
  }

  /// `You can contact support through the submitting the form above this section or email us at neurithm1@gmail.com.`
  String get faq2Answer {
    return Intl.message(
      'You can contact support through the submitting the form above this section or email us at neurithm1@gmail.com.',
      name: 'faq2Answer',
      desc: '',
      args: [],
    );
  }

  /// `Where can I find my history?`
  String get faq3Question {
    return Intl.message(
      'Where can I find my history?',
      name: 'faq3Question',
      desc: '',
      args: [],
    );
  }

  /// `Saved data can be found in the "History" section accessible from the bottom bar.`
  String get faq3Answer {
    return Intl.message(
      'Saved data can be found in the "History" section accessible from the bottom bar.',
      name: 'faq3Answer',
      desc: '',
      args: [],
    );
  }

  /// `Voice Options`
  String get voiceOptions {
    return Intl.message(
      'Voice Options',
      name: 'voiceOptions',
      desc: '',
      args: [],
    );
  }

  /// `Pitch`
  String get pitch {
    return Intl.message('Pitch', name: 'pitch', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Voice`
  String get voice {
    return Intl.message('Voice', name: 'voice', desc: '', args: []);
  }

  /// `Test Voice`
  String get testVoice {
    return Intl.message('Test Voice', name: 'testVoice', desc: '', args: []);
  }

  /// `Text to speak`
  String get textToSpeakLabel {
    return Intl.message(
      'Text to speak',
      name: 'textToSpeakLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter text here...`
  String get textToSpeakHint {
    return Intl.message(
      'Enter text here...',
      name: 'textToSpeakHint',
      desc: '',
      args: [],
    );
  }

  /// `Generate & Play Voice`
  String get playVoice {
    return Intl.message(
      'Generate & Play Voice',
      name: 'playVoice',
      desc: '',
      args: [],
    );
  }

  /// `Playing..`
  String get playing {
    return Intl.message('Playing..', name: 'playing', desc: '', args: []);
  }

  /// `Replay`
  String get replay {
    return Intl.message('Replay', name: 'replay', desc: '', args: []);
  }

  /// `Please enter some text to generate speech.`
  String get enterTextWarning {
    return Intl.message(
      'Please enter some text to generate speech.',
      name: 'enterTextWarning',
      desc: '',
      args: [],
    );
  }

  /// `Your preferences have been saved successfully.`
  String get preferencesSaved {
    return Intl.message(
      'Your preferences have been saved successfully.',
      name: 'preferencesSaved',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Choose Your Preferred\nCorrection`
  String get chooseCorrectionLabel {
    return Intl.message(
      'Choose Your Preferred\nCorrection',
      name: 'chooseCorrectionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Regenerate`
  String get regenerate {
    return Intl.message('Regenerate', name: 'regenerate', desc: '', args: []);
  }

  /// `Recite`
  String get recite {
    return Intl.message('Recite', name: 'recite', desc: '', args: []);
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Reciting Your Thought`
  String get reciteThoughtLabel {
    return Intl.message(
      'Reciting Your Thought',
      name: 'reciteThoughtLabel',
      desc: '',
      args: [],
    );
  }

  /// `Return to Thinking`
  String get returnToThinking {
    return Intl.message(
      'Return to Thinking',
      name: 'returnToThinking',
      desc: '',
      args: [],
    );
  }

  /// `Recite Again`
  String get reciteAgain {
    return Intl.message(
      'Recite Again',
      name: 'reciteAgain',
      desc: '',
      args: [],
    );
  }

  /// `Session Feedback`
  String get sessionFeedback {
    return Intl.message(
      'Session Feedback',
      name: 'sessionFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Conversation History`
  String get conversationHistory {
    return Intl.message(
      'Conversation History',
      name: 'conversationHistory',
      desc: '',
      args: [],
    );
  }

  /// `No conversations found`
  String get noConversationsFound {
    return Intl.message(
      'No conversations found',
      name: 'noConversationsFound',
      desc: '',
      args: [],
    );
  }

  /// `Session Date`
  String get sessionDate {
    return Intl.message(
      'Session Date',
      name: 'sessionDate',
      desc: '',
      args: [],
    );
  }

  /// `Start Time`
  String get startTime {
    return Intl.message('Start Time', name: 'startTime', desc: '', args: []);
  }

  /// `End Time`
  String get endTime {
    return Intl.message('End Time', name: 'endTime', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Are you sure you want to delete this session?`
  String get confirmDelete {
    return Intl.message(
      'Are you sure you want to delete this session?',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Get your headset (Emotiv Epoc X) out of its package.`
  String get step1 {
    return Intl.message(
      'Get your headset (Emotiv Epoc X) out of its package.',
      name: 'step1',
      desc: '',
      args: [],
    );
  }

  /// `Hydrate the sensor felts using saline solution. Do not use contact lens cleaning or sterilizing solutions.`
  String get step2 {
    return Intl.message(
      'Hydrate the sensor felts using saline solution. Do not use contact lens cleaning or sterilizing solutions.',
      name: 'step2',
      desc: '',
      args: [],
    );
  }

  /// `Place the sensor felts in a glass, add saline solution, and soak. Squeeze out excess fluid before inserting them into the sensors.`
  String get step3 {
    return Intl.message(
      'Place the sensor felts in a glass, add saline solution, and soak. Squeeze out excess fluid before inserting them into the sensors.',
      name: 'step3',
      desc: '',
      args: [],
    );
  }

  /// `To rehydrate sensors while using the headset, add saline solution through the top opening of each sensor.`
  String get step4 {
    return Intl.message(
      'To rehydrate sensors while using the headset, add saline solution through the top opening of each sensor.',
      name: 'step4',
      desc: '',
      args: [],
    );
  }

  /// `Insert the sensor felts into each sensor opening and press the power button to turn on the headset. A white LED will illuminate, and the headset will beep. To optimize the use of your headset, we recommend that you fully charge it before making recordings.`
  String get step5 {
    return Intl.message(
      'Insert the sensor felts into each sensor opening and press the power button to turn on the headset. A white LED will illuminate, and the headset will beep. To optimize the use of your headset, we recommend that you fully charge it before making recordings.',
      name: 'step5',
      desc: '',
      args: [],
    );
  }

  /// `Turn on Bluetooth on your phone and navigate to the "Connect to Headset" page.`
  String get step6 {
    return Intl.message(
      'Turn on Bluetooth on your phone and navigate to the "Connect to Headset" page.',
      name: 'step6',
      desc: '',
      args: [],
    );
  }

  /// `Click the big circular button to scan for devices and select the headset when it appears.`
  String get step7 {
    return Intl.message(
      'Click the big circular button to scan for devices and select the headset when it appears.',
      name: 'step7',
      desc: '',
      args: [],
    );
  }

  /// `Once connected, you can start the thought translation process!`
  String get step8 {
    return Intl.message(
      'Once connected, you can start the thought translation process!',
      name: 'step8',
      desc: '',
      args: [],
    );
  }

  /// `Go Back`
  String get goBack {
    return Intl.message('Go Back', name: 'goBack', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
