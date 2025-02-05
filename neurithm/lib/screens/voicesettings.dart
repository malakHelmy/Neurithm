import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/userPreferences.dart';

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

class VoiceSettingsPage extends StatefulWidget {
  @override
  _VoiceSettingsState createState() => _VoiceSettingsState();
}

class _VoiceSettingsState extends State<VoiceSettingsPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  VoiceSettings _userSettings = VoiceSettings(
    pitch: 1.0,
    gender: "male",
    accent: "en-US",
  );
  String _textToSynthesize = "Hello, Malouka habibi.";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load saved preferences
  Future<void> _loadPreferences() async {
    final settings = await UserPreferences.loadVoiceSettings();
    setState(() {
      _userSettings = settings;
    });
  }

  // Save preferences when settings change
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
      print('Sending request to server...');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': text,
          ...settings.toJson(),
        }),
      );

      print('Response received. Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/output.wav';
        File audioFile = File(filePath);
        await audioFile.writeAsBytes(response.bodyBytes);

        print('Audio file saved at: $filePath');

        if (await audioFile.exists()) {
          print('File exists and is ready to play.');
        } else {
          print('File does not exist.');
        }

        print('Attempting to play audio...');
        await _audioPlayer.play(DeviceFileSource(filePath));
        print("Playing audio...");
      } else {
        print(
            'Failed to generate speech: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  bool _isPlaying = false;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Voice Settings")),
      body: Column(
        children: [
          Slider(
            value: _userSettings.pitch,
            min: 0.5,
            max: 2.0,
            onChanged: (value) {
              setState(() {
                _userSettings.pitch = value;
              });
              _savePreferences(); // Save preferences
            },
            divisions: 15,
            label: _userSettings.pitch.toStringAsFixed(2),
          ),
          DropdownButton<String>(
            value: _userSettings.gender,
            onChanged: (value) {
              setState(() {
                _userSettings.gender = value!;
              });
              _savePreferences(); // Save preferences
            },
            items: const [
              DropdownMenuItem(value: "female", child: Text("Female")),
              DropdownMenuItem(value: "male", child: Text("Male")),
            ],
          ),
          DropdownButton<String>(
            value: _userSettings.accent,
            onChanged: (value) {
              setState(() {
                _userSettings.accent = value!;
              });
              _savePreferences(); // Save preferences
            },
            items: const [
              DropdownMenuItem(value: "en-US", child: Text("American English")),
              DropdownMenuItem(value: "ar", child: Text("Arabic")),
            ],
          ),
          ElevatedButton(
            onPressed: _isPlaying
                ? null
                : () async {
                    final directory = await getTemporaryDirectory();
                    final filePath = '${directory.path}/output.wav';
                    await _playAudio(filePath);
                  },
            child: _isPlaying ? Text("Playing...") : Text("Play Audio"),
          ),
        ],
      ),
    );
  }
}
