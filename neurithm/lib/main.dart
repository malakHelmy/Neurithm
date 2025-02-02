import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:neurithm/screens/welcomeScreen.dart';
import 'screens/loginPage.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    name: 'neurithm',
    options: const FirebaseOptions(
      apiKey: "AIzaSyB_ZfiJIMRQv1mHBLOyM9hxnXqRn9A7DC8", // From "api_key"
      authDomain:
          "neurithm-8ac92.firebaseapp.com", // Usually "project_id.firebaseapp.com"
      databaseURL:
          "https://neurithm-8ac92-default-rtdb.firebaseio.com/", // Constructed URL
      projectId: "egywanders", // From "project_id"
      storageBucket: "neurithm-8ac92.firebasestorage.app", // From "storage_bucket"
      messagingSenderId: "49235168369", // From "project_number"
      appId:
          "1:49235168369:android:b283ac169a67724e455fd0", // From "mobilesdk_app_id"
    ),
  );

  runApp(ThoughtToSpeechApp());
}

class ThoughtToSpeechApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A2A3A),
        primaryColor: const Color(0xFF394B58),
      ),
      home: WelcomeScreen(),
    );
  }
}
