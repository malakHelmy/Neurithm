import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:neurithm/screens/welcomePage.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'generated/l10n.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    messagingSenderId: "49235168369",
    appId: "neurithm",
    apiKey: "AIzaSyB_ZfiJIMRQv1mHBLOyM9hxnXqRn9A7DC8",
    authDomain: "neurithm-8ac92.firebaseapp.com",
    databaseURL: "https://neurithm-8ac92-default-rtdb.firebaseio.com",
    projectId: "neurithm-8ac92",
    storageBucket: "neurithm-8ac92.firebasestorage.app",
  ));
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(ThoughtToSpeechApp());
}

class ThoughtToSpeechApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // localizationsDelegates: const [
      //   S.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A2A3A),
        primaryColor: const Color(0xFF394B58),
      ),
      home: WelcomePage(),
    );
  }
}
