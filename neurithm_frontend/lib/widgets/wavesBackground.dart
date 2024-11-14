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
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color.fromARGB(255, 79, 114, 190), // start color

      Color(0xFF1A2A3A), // end color
    ],
  ),
);

//old waves background code
Positioned wavesBackground = Positioned.fill(
  child: Opacity(
    opacity: 0.50, // Adjust opacity as desired
    child: Image.asset(
      'assets/images/waves.jpg', // Your waves image path
      fit: BoxFit.fitHeight,
    ),
  ),
);
