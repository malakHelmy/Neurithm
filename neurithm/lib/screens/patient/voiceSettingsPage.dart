import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neurithm/widgets/wavesBackground.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/bottombar.dart';

class VoiceSettings {
  double pitch;
  String gender;
  String accent;

  VoiceSettings({
    required this.pitch,
    required this.gender,
    required this.accent,
  });

  Map<String, dynamic> toJson() {
    return {
      'pitch': pitch,
      'gender': gender,
      'language': accent,
    };
  }
}

class UserPreferences {
  static const String _pitchKey = 'pitch';
  static const String _genderKey = 'gender';
  static const String _accentKey = 'accent';

  static Future<void> saveVoiceSettings({
    required double pitch,
    required String gender,
    required String accent,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_pitchKey, pitch);
    await prefs.setString(_genderKey, gender);
    await prefs.setString(_accentKey, accent);
  }

  static Future<VoiceSettings> loadVoiceSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return VoiceSettings(
      pitch: prefs.getDouble(_pitchKey) ?? 1.0,
      gender: prefs.getString(_genderKey) ?? 'male',
      accent: prefs.getString(_accentKey) ?? 'en',
    );
  }
}

class VoiceSettingsPage extends StatefulWidget {
  @override
  _VoiceSettingsState createState() => _VoiceSettingsState();
}

class _VoiceSettingsState extends State<VoiceSettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AudioPlayer _audioPlayer = AudioPlayer();

  VoiceSettings _userSettings = VoiceSettings(
    pitch: 1.0,
    gender: "male",
    accent: "en",
  );

  String _textToSynthesize = "Hello, ahahahaha yes of course.";
  bool _isPlaying = false;
  bool _isGenerating = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _textController.text = _textToSynthesize;
  }

  Future<void> _loadPreferences() async {
    final settings = await UserPreferences.loadVoiceSettings();
    setState(() {
      _userSettings = settings;
    });
  }

  Future<void> _savePreferences() async {
    await UserPreferences.saveVoiceSettings(
      pitch: _userSettings.pitch,
      gender: _userSettings.gender,
      accent: _userSettings.accent,
    );
  }

  Future<void> synthesizeSpeech(String text, VoiceSettings settings) async {
    setState(() {
      _isGenerating = true;
    });

    final url = Uri.parse('http://192.168.1.3:5000/synthesize');
    print("synthesizeSpeech");
    try {
      print("inside try");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': text,
          'pitch': settings.pitch,
          'language': settings.accent,
          'gender': settings.gender,
        }),
      );

      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/output.wav';
        File audioFile = File(filePath);
        await audioFile.writeAsBytes(response.bodyBytes);

        print('Audio file saved at: $filePath');

        // Verify the file exists
        bool fileExists = await audioFile.exists();
        print('File exists: $fileExists');

        if (fileExists) {
          await _playAudio(filePath);
        } else {
          print('File does not exist at path: $filePath');
        }
      } else {
        print(
            'Failed to generate speech: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  Future<void> _playAudio(String filePath) async {
    setState(() {
      _isPlaying = true;
    });

    print('Attempting to play audio from: $filePath');

    try {
      await _audioPlayer.play(DeviceFileSource(filePath));
      print('Audio playback started');

      _audioPlayer.onPlayerStateChanged.listen((state) {
        print('Player state: $state');
        if (state == PlayerState.completed) {
          setState(() {
            _isPlaying = false;
          });
          print('Audio playback completed');
        }
      });
    } catch (e) {
      print('Error playing audio: $e');
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize(double size) => size * screenWidth / 400;
    double spacing(double size) => size * screenHeight / 800;

    return Scaffold(
      key: _scaffoldKey,
      drawer: sideAppBar(context),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(spacing(5)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: BottomBar(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: gradientBackground,
          child: Stack(
            children: [
              wavesBackground(screenWidth, screenHeight),
              Column(
                children: [
                  appBar(_scaffoldKey),
                  Padding(
                    padding: EdgeInsets.all(spacing(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF1A2A3A).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.all(spacing(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Voice Options",
                                style: TextStyle(
                                  fontSize: fontSize(24),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: spacing(20)),
                              Text(
                                "Pitch",
                                style: TextStyle(
                                  fontSize: fontSize(18),
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.height, color: Colors.grey),
                                  Expanded(
                                    child: Slider(
                                      value: _userSettings.pitch,
                                      min: 0.5,
                                      max: 2.0,
                                      onChanged: (value) {
                                        setState(() {
                                          _userSettings.pitch = value;
                                        });
                                        _savePreferences();
                                      },
                                      divisions: 15,
                                      label: _userSettings.pitch
                                          .toStringAsFixed(2),
                                      activeColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: spacing(20)),
                              Text(
                                "Language",
                                style: TextStyle(
                                  fontSize: fontSize(18),
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: spacing(8)),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: spacing(12)),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: DropdownButton<String>(
                                  value: _userSettings.accent,
                                  onChanged: (value) {
                                    setState(() {
                                      _userSettings.accent = value!;
                                    });
                                    _savePreferences();
                                  },
                                  items: const [
                                    DropdownMenuItem(
                                        value: "en",
                                        child: Text("English",
                                            style: TextStyle(
                                                color: Colors.white))),
                                    DropdownMenuItem(
                                        value: "ar",
                                        child: Text("Arabic",
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ],
                                  isExpanded: true,
                                  dropdownColor: Color(0xFF1A2A3A),
                                  underline: SizedBox(),
                                ),
                              ),
                              SizedBox(height: spacing(20)),
                              Text(
                                "Gender",
                                style: TextStyle(
                                  fontSize: fontSize(18),
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: spacing(8)),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: spacing(12)),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: DropdownButton<String>(
                                  value: _userSettings.gender,
                                  onChanged: (value) {
                                    setState(() {
                                      _userSettings.gender = value!;
                                    });
                                    _savePreferences();
                                  },
                                  items: const [
                                    DropdownMenuItem(
                                        value: "male",
                                        child: Text("Male",
                                            style: TextStyle(
                                                color: Colors.white))),
                                    DropdownMenuItem(
                                        value: "female",
                                        child: Text("Female",
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ],
                                  isExpanded: true,
                                  dropdownColor: Color(0xFF1A2A3A),
                                  underline: SizedBox(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: spacing(16)),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF1A2A3A).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.all(spacing(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Test Voice",
                                style: TextStyle(
                                  fontSize: fontSize(24),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: spacing(16)),
                              TextField(
                                controller: _textController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  labelText: 'Text to speak',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  hintText: 'Enter text here...',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  fillColor: Colors.white.withOpacity(0.1),
                                  filled: true,
                                ),
                                maxLines: 3,
                                onChanged: (value) {
                                  _textToSynthesize = value;
                                },
                              ),
                              SizedBox(height: spacing(16)),
                              Column(
                               
                                children: [
                                 SizedBox(
                                  width: double.infinity,
                                   child: ElevatedButton.icon(
                                        onPressed: _isGenerating
                                            ? null
                                            : () {
                                                synthesizeSpeech(
                                                    _textToSynthesize,
                                                    _userSettings);
                                              },
                                        icon: Icon(Icons.record_voice_over),
                                        label: Text(
                                          "Generate & Play Voice",
                                          style:
                                              TextStyle(fontSize: fontSize(20)),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Color(0xFF1A2A3A),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: spacing(20),
                                            vertical: spacing(12),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                      ),
                                 ),
                                  
                                  SizedBox(height: 15,),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                        onPressed: _isPlaying || _isGenerating
                                            ? null
                                            : () async {
                                                final directory =
                                                    await getTemporaryDirectory();
                                                final filePath =
                                                    '${directory.path}/output.wav';
                                                await _playAudio(filePath);
                                              },
                                        icon: Icon(_isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow),
                                        label: Text(
                                          _isPlaying ? "Playing.." : "Replay",
                                          style:
                                              TextStyle(fontSize: fontSize(20)),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Color(0xFF1A2A3A),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: spacing(20),
                                            vertical: spacing(12),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                      ),
                                  ),
                                  
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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
