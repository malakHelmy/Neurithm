import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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
  final TTSService _ttsService = TTSService();
  // Store the path of the generated audio file
  late AnimationController _animationController;
  late Timer _waveTimer;
  List<double> waveHeights = List.filled(20, 0); // Initial wave heights
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isGenerating = false;
  String? _audioFilePath;

  @override
  void initState() {
    super.initState();

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
    String? filePath = _ttsService.synthesizeSpeech(text) as String?;
    if(filePath == "error") return;
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

    try {
      await _audioPlayer.play(DeviceFileSource(filePath));
      print('Audio playback started');

      _audioPlayer.onPlayerStateChanged.listen((state) {
        if (!mounted) return; // Check if the widget is still mounted
        print('Player state: $state');
        if (state == PlayerState.completed) {
          if (mounted) {
            setState(() {
              _isPlaying = false;
            });
          }
          print('Audio playback completed');
        }
      });
    } catch (e) {
      print('Error playing audio: $e');
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  Future<void> _reciteAgain() async {
    if (!mounted) return;

    if (_audioFilePath != null) {
      // If audio file already exists, play it immediately
      await _playAudio(_audioFilePath!);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                  const Text(
                    'Reciting Your Thought',
                    style: TextStyle(
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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.psychology,
                            color: Color(0xFF1A2A3A),
                            size: 25,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Return to Thinking",
                            style: TextStyle(
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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.replay,
                            color: Color(0xFF1A2A3A),
                            size: 25,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Recite Again",
                            style: TextStyle(
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
                      onPressed: () {
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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Color(0xFF1A2A3A),
                            size: 25,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Finish",
                            style: TextStyle(
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
