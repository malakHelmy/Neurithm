import 'package:flutter/material.dart';
import 'package:neurithm/screens/feedbackScreen.dart';
import '../widgets/appBar.dart';
import '../widgets/wavesBackground.dart';
import 'recitePage.dart';

class ConfirmationPage extends StatefulWidget {
  final String processedSentence;

  const ConfirmationPage({super.key, required this.processedSentence});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  bool _isRegenerating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: gradientBackground,
        child: Stack(
          alignment: Alignment.center,
          children: [
            wavesBackground(getScreenWidth(context), getScreenHeight(context)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing(15, getScreenHeight(context)),
              ),
              child: _isRegenerating
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Regenerating...",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: spacing(20, getScreenHeight(context)),
                          ),
                          child: const Text(
                            'Review Your Thought:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Lato',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(
                              spacing(20, getScreenHeight(context))),
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
                            widget.processedSentence,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: spacing(40, getScreenHeight(context))),
                        _actionButtons(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _isRegenerating = true);

                    // Simulate "regeneration" process
                    Future.delayed(const Duration(seconds: 3), () {
                      if (mounted) {
                        setState(() => _isRegenerating = false);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: spacing(12, getScreenHeight(context))),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, color: Color(0xFF1A2A3A), size: 20),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecitePage(sentence: widget.processedSentence),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: spacing(12, getScreenHeight(context))),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.volume_up, color: Color(0xFF1A2A3A), size: 20),
                      SizedBox(width: 5),
                      Text(
                        "Recite",
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
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
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
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
