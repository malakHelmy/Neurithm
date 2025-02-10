import 'package:flutter/material.dart';
import 'package:neurithm/screens/feedbackScreen.dart';

import '../widgets/appBar.dart';
import '../widgets/wavesBackground.dart';
import 'homePage.dart';
import '../screens/confirmationPage.dart';

class Signalreadingpage extends StatelessWidget {
  const Signalreadingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: gradientBackground,
        child: Stack(
          children: [
            wavesBackground(getScreenWidth(context), getScreenHeight(context)),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: spacing(15, getScreenHeight(context))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Processing Text
                    const Text(
                      'Processing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Lato',
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Text(
                      'Reading and analyzing your signal data',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lato',
                      ),
                    ),
                    SizedBox(height: spacing(25, getScreenHeight(context))),
                    // Processing Animation
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF1A2A3A),
                          ),
                          strokeWidth: 4,
                        ),
                      ),
                    ),
                    SizedBox(height: spacing(30, getScreenHeight(context))),
                    // Finish Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          String sentence = "This is the sentence to be recited";
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ConfirmationPage(processedSentence: sentence),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1A2A3A),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: spacing(15, getScreenHeight(context)),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF1A2A3A),
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "I'm done thinking",
                              style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 0.5,
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
          ],
        ),
      ),
    );
  }
}