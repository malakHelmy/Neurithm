import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:neurithm/l10n/generated/app_localizations.dart';
import 'package:neurithm/models/patient.dart';
import 'package:neurithm/models/userPreferences.dart';
import 'package:neurithm/models/voiceSettings.dart';
import 'package:neurithm/services/authService.dart';
import 'package:neurithm/services/signalReadingService.dart';
import 'package:neurithm/services/ttsService.dart';
import 'package:neurithm/screens/patient/feedbackPage.dart';
import 'package:neurithm/screens/patient/signalReadingPage.dart';
import 'package:neurithm/widgets/wavesBackground.dart';

class ReciteContextPage extends StatefulWidget {
  final String sentence;

  const ReciteContextPage({super.key, required this.sentence});

  @override
  _ReciteContextPageState createState() => _ReciteContextPageState();
}

class _ReciteContextPageState extends State<ReciteContextPage>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final SignalReadingService signalReadingService = SignalReadingService();
  final TTSService _ttsService = TTSService();
  late AnimationController _animationController;
  late Timer _waveTimer;
  List<double> waveHeights = List.filled(20, 0);
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isGenerating = false;
  String? _audioFilePath;
  Patient? _currentUser;

  Future<void> _fetchUser() async {
    Patient? user = await _authService.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();

    // Initialize Animation Controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    // Start dynamic wave animation
    _startWaveAnimation();

    // Start Coqui TTS and play audio immediately
    synthesizeSpeech(widget.sentence);
  }

  void _startWaveAnimation() {
    _waveTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        waveHeights = List.generate(
          20,
          (_) =>
              Random().nextDouble() * 50 +
              10, // Random heights between 10 and 60
        );
      });
    });
  }

  Future<void> synthesizeSpeech(String text) async {
    if (!mounted) return;

    setState(() {
      _isGenerating = true;
    });
    VoiceSettings settings = await UserPreferences.loadVoiceSettings();
    String? audioFilePath = await _ttsService.synthesizeSpeech(text);
    if (audioFilePath != "error") {
      await _audioPlayer.setPitch(settings.pitch);
      await _audioPlayer.setFilePath(audioFilePath!);
      await _audioPlayer.play();
      print("Audio file path: $audioFilePath");
    } else {
      print("Failed to synthesize speech.");
    }
    setState(() {
      _audioFilePath = audioFilePath;
    });

    setState(() {
      _isGenerating = false;
    });
  }

  Future<void> _reciteAgain() async {
    if (!mounted) return;
    VoiceSettings settings = await UserPreferences.loadVoiceSettings();

    if (_audioFilePath != null) {
      await _audioPlayer.setPitch(settings.pitch);
      await _audioPlayer.setFilePath(_audioFilePath!);
      await _audioPlayer.play();
    } else {
      // If audio file doesn't exist, generate it first
      await synthesizeSpeech(widget.sentence);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _waveTimer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: gradientBackground,
        child: Stack(children: [
          waveBackground,
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    t.reciteThoughtLabel,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomPaint(
                    size: const Size(200, 100),
                    painter: WavePainter(waveHeights),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.sentence,
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignalReadingpage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 240, 240, 240),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.psychology,
                            color: Color(0xFF1A2A3A),
                            size: 25,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            t.returnToThinking,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF1A2A3A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isPlaying
                          ? null
                          : () {
                              _reciteAgain();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 240, 240, 240),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.replay,
                            color: Color(0xFF1A2A3A),
                            size: 25,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            t.reciteAgain,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF1A2A3A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_currentUser != null) {
                          await signalReadingService
                              .updateEndTimeByPatientId(_currentUser!.uid);
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FeedbackPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF1A2A3A),
                            size: 25,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            t.finish,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final List<double> waveHeights;

  WavePainter(this.waveHeights);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    final double barWidth = size.width / waveHeights.length;
    for (int i = 0; i < waveHeights.length; i++) {
      final x = i * barWidth + barWidth / 2;
      final y1 = size.height / 2 - waveHeights[i] / 2;
      final y2 = size.height / 2 + waveHeights[i] / 2;
      canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
