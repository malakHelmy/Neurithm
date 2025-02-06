import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  VoiceSettings _userSettings = VoiceSettings(
    pitch: 1.0,
    gender: "male",
    accent: "en",
  );
  
  String _textToSynthesize = "Hello, ahahahaha yes of course.";
  bool _isPlaying = false;
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
    final url = Uri.parse('http://192.168.100.26:5000/synthesize');

    try {
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
        await _playAudio(filePath);
      } else {
        print('Failed to generate speech: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _playAudio(String filePath) async {
    setState(() {
      _isPlaying = true;
    });

    await _audioPlayer.play(DeviceFileSource(filePath));

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice Settings"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Voice Options",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Pitch",
                        style: Theme.of(context).textTheme.titleMedium,
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
                              label: _userSettings.pitch.toStringAsFixed(2),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Language",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
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
                            DropdownMenuItem(value: "en", child: Text("English")),
                            DropdownMenuItem(value: "ar", child: Text("Arabic")),
                          ],
                          isExpanded: true,
                          underline: SizedBox(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Gender",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
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
                            DropdownMenuItem(value: "male", child: Text("Male")),
                            DropdownMenuItem(value: "female", child: Text("Female")),
                          ],
                          isExpanded: true,
                          underline: SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Test Voice",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Text to speak',
                          hintText: 'Enter text here...',
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          _textToSynthesize = value;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              synthesizeSpeech(_textToSynthesize, _userSettings);
                            },
                            icon: Icon(Icons.record_voice_over),
                            label: Text("Generate & Play Voice"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _isPlaying
                                ? null
                                : () async {
                                    final directory = await getTemporaryDirectory();
                                    final filePath = '${directory.path}/output.wav';
                                    await _playAudio(filePath);
                                  },
                            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                            label: _isPlaying ? Text("Playing...") : Text("Replay"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}