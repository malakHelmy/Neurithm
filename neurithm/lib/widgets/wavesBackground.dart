import 'package:flutter/material.dart';

const BoxDecoration gradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 79, 114, 190), // start color
      Color(0xFF1A2A3A), // end color
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

//old waves background code
Positioned waveBackground = Positioned.fill(
  child: Opacity(
    opacity: 0.50, // Adjust opacity as desired
    child: Image.asset(
      'assets/images/waves.jpg', // Your waves image path
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
        'assets/images/waves.jpg', // Your waves image path
        fit: BoxFit.fitHeight,
      ),
    ),
  );
}
