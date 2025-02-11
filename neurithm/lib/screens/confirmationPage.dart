import 'package:flutter/material.dart';
import 'package:neurithm/screens/feedbackScreen.dart';

import '../widgets/appBar.dart';
import '../widgets/wavesBackground.dart';
import 'homePage.dart';
import '../screens/recitePage.dart';

class ConfirmationPage extends StatelessWidget {
  final String processedSentence;

  const ConfirmationPage({super.key, required this.processedSentence});

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
                        'Review Your Thought: ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.all(spacing(20, getScreenHeight(context))),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 29, 29, 29)
                            .withOpacity(0.35),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        processedSentence,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        textAlign: TextAlign.center,
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
                                    "Regenerate",
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
                               // String sentence =
                                 //   "This is the sentence to be recited"; // Replace with your dynamic sentence
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecitePage(
                                   sentence: processedSentence, // Use the actual predicted text
                                    ),
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
                                    "Recite",
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Action to finish the process
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FeedbackScreen(), // Push to the FeedbackScreen
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Green background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: spacing(12, getScreenHeight(context))),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Finish",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.white, // White text for contrast
                              ),
                            ),
                          ],
                        ),
                      ),
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
