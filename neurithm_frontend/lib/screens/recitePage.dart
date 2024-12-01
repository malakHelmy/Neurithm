import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:neurithm_frontend/widgets/wavesBackground.dart';

class RecitePage extends StatefulWidget {
  final String sentence;

  const RecitePage({super.key, required this.sentence});

  @override
  _RecitePageState createState() => _RecitePageState();
}

class _RecitePageState extends State<RecitePage>
    with SingleTickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();
  late AnimationController _animationController;
  late Timer _waveTimer;
  List<double> waveHeights = List.filled(20, 0); // Initial wave heights

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

    // Start TTS
    _speak(widget.sentence);
  }

  void _startWaveAnimation() {
    _waveTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
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

  Future<void> _speak(String sentence) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.speak(sentence);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _waveTimer.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  // Dynamic Wave Animation
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
                        Navigator.popUntil(context, (route) => route.isFirst);
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
                            Icons.home,
                            color: Color(0xFF1A2A3A),
                            size: 25,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Return to Home",
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
    return true; // Repaint when waveHeights updates
  }
}
