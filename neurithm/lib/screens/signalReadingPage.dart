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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: spacing(20, getScreenHeight(context))),
                      child: const Text(
                        'Processing',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                   
                    SizedBox(height: spacing(40, getScreenHeight(context))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Action to regenerate the sentence
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    color: Color(0xFF1A2A3A),
                                    size: 20,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Begin",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF1A2A3A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Action to accept the sentence
                                String sentence =
                                    "This is the sentence to be recited"; // Replace with your dynamic sentence
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConfirmationPage(
                                        processedSentence:
                                            processedSentence), // Pass sentence here
                                  ),
                                );
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.volume_up,
                                    color: Color(0xFF1A2A3A),
                                    size: 20,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Finish",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Color(
                                          0xFF1A2A3A), // White text for contrast
                                    ),
                                  ),
                                ],
                              ),
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
