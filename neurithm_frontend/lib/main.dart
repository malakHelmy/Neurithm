import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(ThoughtToSpeechApp());
}

class ThoughtToSpeechApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF1A2A3A),
        primaryColor: Color(0xFF394B58),
      ),
      home: HomePage(),
    );
  }
}
