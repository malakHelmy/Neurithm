import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:neurithm/widgets/wavesBackground.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class RecitePage extends StatefulWidget {
  final String sentence;

  const RecitePage({super.key, required this.sentence});

  @override
  _RecitePageState createState() => _RecitePageState();
}

class _RecitePageState extends State<RecitePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Timer _waveTimer;
  List<double> waveHeights = List.filled(20, 0); // Initial wave heights
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isGenerating = false;
  String? _audioFilePath; // Store the path of the generated audio file

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
    String? accessToken = dotenv.env['GOOGLE_CLOUD_TTS_API_KEY'];
    if (!mounted) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      final url = Uri.parse(
          'https://texttospeech.googleapis.com/v1/text:synthesize?key=$accessToken');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "input": {"text": text},
          "voice": {
            "languageCode": "ar-XA", // Arabic voice
            "name": "ar-XA-Standard-D" // Example Arabic voice
          },
          "audioConfig": {
            "audioEncoding": "LINEAR16" // WAV format
          }
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String audioContent = responseData['audioContent'];

        if (audioContent != null) {
          final directory = await getTemporaryDirectory();
          final filePath = '${directory.path}/output.wav';
          File audioFile = File(filePath);
          await audioFile.writeAsBytes(base64Decode(audioContent));

          setState(() {
            _audioFilePath = filePath;
          });

          await _playAudio(filePath);
        }
      } else {
        print(
            'Failed to generate speech: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in synthesizeSpeech: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _playAudio(String filePath) async {
    if (!mounted) return; // Check if the widget is still mounted

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
    if (!mounted) return; // Check if the widget is still mounted

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