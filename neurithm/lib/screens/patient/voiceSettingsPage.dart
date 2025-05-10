import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:neurithm/widgets/wavesBackground.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/bottombar.dart';
import 'package:neurithm/services/ttsService.dart';
import 'package:neurithm/services/voiceSettingService.dart';
import 'package:neurithm/models/voiceSettings.dart';
import 'package:neurithm/models/userPreferences.dart';

class VoiceSettingsPage extends StatefulWidget {
  @override
  _VoiceSettingsState createState() => _VoiceSettingsState();
}

class _VoiceSettingsState extends State<VoiceSettingsPage> {
  final TTSService _ttsService = TTSService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _audioPlayer = AudioPlayer();
  String? _audioFilePath;
  final VoiceSettingService _voiceSettingService = VoiceSettingService();

  //default voice
  VoiceSettings _userSettings = VoiceSettings(
    pitch: 1.0,
    gender: "female",
    language: "en-US",
    voiceName: "Aoede",
  );
  List<String> _availableVoices = [];
  String? _selectedVoice;

  String _textToSynthesize = "Sample text to listen to the voice";
  bool _isPlaying = false;
  bool _isGenerating = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _textController.text = _textToSynthesize;
  }

  void _updateVoiceList() {
    setState(() {
      if (_userSettings.gender == "male") {
        _userSettings.voiceName = "Puck";
        _availableVoices = _voiceSettingService.maleVoices;
      }
      if (_userSettings.gender == "female") {
        _userSettings.voiceName = "Aoede";

        _availableVoices = _voiceSettingService.femaleVoices;
      }

      _selectedVoice = _availableVoices.isNotEmpty ? _availableVoices[0] : null;
    });
  }

  Future<void> _loadPreferences() async {
    final settings = await UserPreferences.loadVoiceSettings();
    if (settings != null) {
      setState(() {
        _userSettings = settings;
      });
    }
  }

  Future<void> _savePreferences() async {
    await UserPreferences.saveVoiceSettings(_userSettings);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Your preferences have been saved successfully."),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  Future<void> synthesizeSpeech(String text) async {
    if (!mounted || text.trim().isEmpty) return;

    setState(() {
      _isGenerating = true;
    });
    String? filePath =
        await _ttsService.synthesizeSpeechWithSettings(text, _userSettings);
    if (filePath == "error") return;
    setState(() {
      _audioFilePath = filePath;
    });

    await _playAudio(filePath!);
    setState(() {
      _isGenerating = false;
    });
  }

  Future<void> _playAudio(String filePath) async {
    if (!mounted) return;

    setState(() {
      _isPlaying = true;
    });

    print('Attempting to play audio from: $filePath');

    if (filePath != "error") {      
      await _audioPlayer.setPitch(_userSettings.pitch);
      await _audioPlayer.setFilePath(filePath);
      await _audioPlayer.play();
      print("Audio file path: $filePath");
      setState(() {
        _isPlaying = false;
      });
      // Add audio playing logic here, for example using the `audioplayers` package
    } else {
      print("Failed to synthesize speech.");
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
          child: BottomBar(context, 2),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: gradientBackground,
          child: Stack(
            children: [
              waveBackground,
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
                                      min: 0.7,
                                      max: 1.5,
                                      onChanged: (value) {
                                        setState(() {
                                          _userSettings.pitch = value;
                                        });
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
                                  value: _userSettings.language,
                                  onChanged: (value) {
                                    setState(() {
                                      _userSettings.language = value!;
                                    });
                                  },
                                  items: const [
                                    DropdownMenuItem(
                                        value: "en-US",
                                        child: Text("English",
                                            style: TextStyle(
                                                color: Colors.white))),
                                    DropdownMenuItem(
                                        value: "ar-XA",
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
                                      _updateVoiceList();
                                    });
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
                              SizedBox(height: spacing(20)),
                              Text(
                                "Voice",
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
                                  value: _userSettings.voiceName,
                                  onChanged: (value) {
                                    setState(() {
                                      _userSettings.voiceName = value!;
                                    });
                                  },
                                  items: _availableVoices.map((voice) {
                                    return DropdownMenuItem(
                                        value: voice, child: Text(voice));
                                  }).toList(),
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
                                              if (_textToSynthesize
                                                  .trim()
                                                  .isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        "Please enter some text to generate speech."),
                                                    backgroundColor:
                                                        Colors.white,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    duration:
                                                        Duration(seconds: 2),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    margin: EdgeInsets.all(16),
                                                  ),
                                                );
                                              } else {
                                                synthesizeSpeech(
                                                    _textToSynthesize);
                                              }
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
                                  SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: _isPlaying || _isGenerating
                                          ? null
                                          : () async {
                                              await _playAudio(_audioFilePath!);
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
                                  SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _savePreferences();
                                      },
                                      icon: Icon(Icons.record_voice_over),
                                      label: Text(
                                        "Save Changes",
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
