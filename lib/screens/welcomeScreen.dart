import 'package:flutter/material.dart';
import '../widgets/wavesBackground.dart';

import 'loginPage.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  bool _showLogo = true; // Controls logo visibility
  int _currentSlideIndex = 0; // Tracks the current slide in the slideshow

  // Slide data: Each slide contains a title, icon, and description
  final List<Map<String, dynamic>> _slides = [
    {
      "title": "Welcome to Neurithm",
      "icon": Icons.waves, // Represents signals or brainwaves
      "description":
          "Pioneering the path where brain signals transform into meaningful communication.",
    },
    {
      "title": "Empowering Voices",
      "icon": Icons.mic, // Represents speech and communication
      "description":
          "Helping individuals who lost their ability to speak rediscover their voice with groundbreaking technology.",
    },
    {
      "title": "Innovation That Matters",
      "icon":
          Icons.accessibility_new, // Represents empowerment and accessibility
      "description":
          "Making communication accessible for everyone, empowering lives and breaking barriers.",
    },
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Fade duration
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // Show the logo screen for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _showLogo = false;
    });
    _animationController.forward(); // Start fading in the first slide
  }

  void _navigateToLoginPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _nextSlide() async {
    if (_currentSlideIndex < _slides.length - 1) {
      await _animationController.reverse(); // Fade out current slide
      setState(() {
        _currentSlideIndex++;
      });
      _animationController.forward(); // Fade in the next slide
    } else {
      _navigateToLoginPage();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: darkGradientBackground,
        child: Stack(
          children: [
            // Background image with waves
            AspectRatio(
              aspectRatio: screenWidth / screenHeight,
              child: Opacity(
                opacity: 0.30,
                child: Image.asset(
                  'assets/images/waves.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Logo Screen
            Center(
              child: AnimatedOpacity(
                opacity: _showLogo ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: _showLogo
                    ? const Text(
                        "Neurithm",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Vonique',
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            // Slideshow Content
            if (!_showLogo)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _slides[_currentSlideIndex]['icon'],
                        size: 200,
                        color: Colors.white70,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _slides[_currentSlideIndex]['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          _slides[_currentSlideIndex]['description'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Buttons at the bottom
            if (!_showLogo)
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _nextSlide,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          _currentSlideIndex < _slides.length - 1
                              ? "Next"
                              : "Get Started",
                          style: const TextStyle(
                            color: Color(0xFF1A2A3A),
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _navigateToLoginPage,
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
