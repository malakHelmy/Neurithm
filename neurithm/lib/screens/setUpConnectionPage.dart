import 'package:flutter/material.dart';
import '../widgets/appBar.dart';
import '../widgets/wavesBackground.dart';
import 'homePage.dart';
import '../screens/signalReadingPage.dart';

class setUpConnectionPage extends StatefulWidget {
  const setUpConnectionPage({super.key});

  @override
  State<setUpConnectionPage> createState() => _setUpConnectionPageState();
}

class _setUpConnectionPageState extends State<setUpConnectionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isScanning = false;
  bool _isScanComplete = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isScanComplete = true;
          });
        }
      });
  }

  void _startScanning() {
    setState(() {
      _isScanning = true;
      _isScanComplete = false;
    });
    _controller.repeat();
    Future.delayed(const Duration(seconds: 5), () {
      _controller.stop();
      setState(() {
        _isScanning = false;
        _isScanComplete = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradientBackground,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              wavesBackground(
                  getScreenWidth(context), getScreenHeight(context)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: spacing(15, getScreenHeight(context))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: getScreenHeight(context) * 0.1),
                      child: const Text(
                        'Connect to a Headset',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                    SizedBox(height: spacing(20, getScreenHeight(context))),
                    // Center the description text
                    const Center(
                      child: Text(
                        "Sync your mobile app to your headset to start voicing your thoughts",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 206, 206, 206),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center, // Center-align text
                      ),
                    ),
                    SizedBox(height: spacing(50, getScreenHeight(context))),

                    Container(
                      height: spacing(300, getScreenHeight(context)),
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_isScanning) ...[
                            RippleCircle(
                                animation: _controller,
                                radius: 350,
                                opacity: 0.3),
                            RippleCircle(
                                animation: _controller,
                                radius: 300,
                                opacity: 0.5),
                            RippleCircle(
                                animation: _controller,
                                radius: 250,
                                opacity: 0.7),
                          ],
                          GestureDetector(
                            onTap: _isScanning ? null : _startScanning,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 62, 99, 135),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 62, 99, 135)
                                            .withOpacity(0.4),
                                    spreadRadius: 4,
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              width: spacing(250, getScreenHeight(context)),
                              height: spacing(250, getScreenHeight(context)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 25),
                                  child: Image.asset(
                                    'assets/images/bci.png', // Your waves image path
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        _isScanning
                            ? "Scanning..." // Show "Scanning..." during scanning
                            : _isScanComplete
                                ? "Emotiv epoc-123 headset was found" // Show "Headset was found" after scanning completes
                                : "",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 254, 255, 255),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: spacing(80, getScreenHeight(context))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 165,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 240, 240),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      spacing(12, getScreenHeight(context))),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Color(0xFF1A2A3A),
                                  size: 20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Go Back",
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
                        SizedBox(
                          width: 165,
                          child: ElevatedButton(
                            onPressed: _isScanComplete
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Signalreadingpage(
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 240, 240),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      spacing(12, getScreenHeight(context))),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Next",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF1A2A3A),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF1A2A3A),
                                  size: 20,
                                ),
                              ],
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
      ),
    );
  }
}

class RippleCircle extends StatelessWidget {
  final Animation<double> animation;
  final double radius;
  final double opacity;

  const RippleCircle({
    required this.animation,
    required this.radius,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromARGB(255, 62, 99, 135)
                .withOpacity(opacity * (1 - animation.value)),
          ),
        );
      },
    );
  }
}