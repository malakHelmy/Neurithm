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
