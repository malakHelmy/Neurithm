import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  FlutterTts _flutterTts = FlutterTts();
  double _pitch = 1.0; 
  String _selectedGender = "male"; 
  String _selectedAccent = "en-US"; 

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  void _initializeTts() {
    _flutterTts.setLanguage(_selectedAccent);
    _flutterTts.setSpeechRate(1.2); 
    _flutterTts.setVolume(1.0); 
    _flutterTts.setPitch(_pitch);
    _flutterTts.setVoice({'name': _selectedGender, 'accent': _selectedAccent});
  }

  void _setPitch(double pitch) {
    setState(() {
      _pitch = pitch;
    });
    _flutterTts.setPitch(_pitch);
    _playDemo(); 
  }

  void _setGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    _flutterTts.setVoice({'name': _selectedGender, 'accent': _selectedAccent});
    _playDemo(); 
  }

  void _setAccent(String accent) {
    setState(() {
      _selectedAccent = accent;
    });
    _flutterTts.setLanguage(_selectedAccent);
    _flutterTts.setVoice({'name': _selectedGender, 'locale': _selectedAccent});
    _playDemo(); 
  }

  

  Future<void> _playDemo() async {
    await _flutterTts.stop(); 
    await _flutterTts.speak("Hello, what's on your mind today?"); 
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize(double size) => size * screenWidth / 400;
    double spacing(double size) => size * screenHeight / 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Model Settings'),
        backgroundColor: const Color.fromARGB(255, 70, 100, 166),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 79, 114, 190),
                Color(0xFF1A2A3A),
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: spacing(20),
            vertical: spacing(50),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Adjust Pitch
              Text(
                "Adjust Pitch (Tone)",
                style: TextStyle(
                  fontSize: fontSize(15),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: spacing(20)),
              Slider(
                value: _pitch,
                min: 0.5,
                max: 2.0,
                onChanged: _setPitch,
                divisions: 15,
                label: _pitch.toStringAsFixed(2),
              ),

              // Select Gender
              SizedBox(height: spacing(30)),
              Text(
                "Select Gender",
                style: TextStyle(
                  fontSize: fontSize(15),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: spacing(10)),
              DropdownButton<String>(
                value: _selectedGender,
                dropdownColor: const Color(0xFF1A2A3A),
                onChanged: (value) => _setGender(value!),
                items: const [
                  DropdownMenuItem(
                    value: "female",
                    child: Text(
                      "Female",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "male",
                    child: Text(
                      "Male",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              // Select Accent
              SizedBox(height: spacing(30)),
              Text(
                "Select Accent",
                style: TextStyle(
                  fontSize: fontSize(15),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: spacing(10)),
              DropdownButton<String>(
                value: _selectedAccent,
                dropdownColor: const Color(0xFF1A2A3A),
                onChanged: (value) => _setAccent(value!),
                items: const [
                  DropdownMenuItem(
                    value: "en-US",
                    child: Text(
                      "American English",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "en-GB",
                    child: Text(
                      "British English",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "en-AU",
                    child: Text(
                      "Australian English",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
