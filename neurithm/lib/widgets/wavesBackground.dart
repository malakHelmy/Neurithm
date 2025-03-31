import 'package:flutter/material.dart';

const BoxDecoration gradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 79, 114, 190), 
      Color(0xFF1A2A3A), 
    ],
  ),
);
const BoxDecoration darkGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    colors: [Color(0xFF1A2A3A), Color(0xFF243B4D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);

Positioned waveBackground = Positioned.fill(
  child: Opacity(
    opacity: 0.50,
    child: Image.asset(
      'assets/images/waves.jpg',
      fit: BoxFit.cover,
    ),
  ),
);

AspectRatio wavesBackground(screenWidth, screenHeight) {
  return AspectRatio(
    aspectRatio: screenWidth / screenHeight,
    child: Opacity(
      opacity: 0.50,
      child: Image.asset(
        'assets/images/waves.jpg',
        fit: BoxFit.fitHeight,
      ),
    ),
  );
}
