import 'package:flutter/material.dart';
import 'package:neurithm/models/patient.dart';
import 'package:neurithm/screens/patient/feedbackPage.dart';
import 'package:neurithm/screens/patient/reciteContextPage.dart';
import 'package:neurithm/services/authService.dart';
import 'package:neurithm/services/confirmContextService.dart';
import 'package:neurithm/services/signalReadingService.dart';
import 'package:neurithm/widgets/appBar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';

class ConfirmContextPage extends StatefulWidget {
  final List<String> correctedTexts;
   final String sessionId;

  const ConfirmContextPage({
    super.key,
    required this.correctedTexts,
    required this.sessionId
  });

  @override
  State<ConfirmContextPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmContextPage> {
  final AuthService _authService = AuthService();
  final SignalReadingService signalReadingService = SignalReadingService();
  final ConfirmContextService confirmContextService = ConfirmContextService();
  bool _isRegenerating = false;
  String? _selectedText;
  Patient? _currentUser;
  bool _regenerationDone = false;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    Patient? user = await _authService.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  // Action for "Regenerate"
  Future<void> _handleRegenerate() async {
    if (_selectedText != null) {
      try {
        String aiModelId = await confirmContextService.getAiModelId('EEG Transformer');

        await confirmContextService.addPrediction(
          sessionId: widget.sessionId,
          aiModelId: aiModelId,  
          predictedText: _selectedText!,
          isAccepted: false,
        );

        setState(() {
          _regenerationDone = true;
          _isRegenerating = true;
        });

        await Future.delayed(const Duration(seconds: 3), () {
          setState(() => _isRegenerating = false);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // Action for "Recite"
  Future<void> _handleRecite() async {
    if (_selectedText != null) {
      try {
        String aiModelId;

        if (_regenerationDone) {
          aiModelId = await confirmContextService.getAiModelId('EEG Transformer');
        } else {
          aiModelId = await confirmContextService.getAiModelId('EEGNet');
        }

        await confirmContextService.addPrediction(
          sessionId: widget.sessionId,
          aiModelId: aiModelId,  
          predictedText: _selectedText!,
          isAccepted: true,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReciteContextPage(sentence: _selectedText!),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

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
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        SizedBox(height: 20),
                        Text(
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
                            'Choose Your Preferred Correction:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Lato',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Display all corrected text options
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.correctedTexts.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedText =
                                          widget.correctedTexts[index];
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _selectedText ==
                                            widget.correctedTexts[index]
                                        ? Colors.blue
                                        : Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                  ),
                                  child: Text(
                                    widget.correctedTexts[index],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              );
                            },
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
                  onPressed: ()  {
                         _handleRegenerate();
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
                  onPressed: _selectedText == null
                      ? null
                      : ()  {
                         _handleRecite();
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
            onPressed: () async {
              if (_currentUser != null) {
                await signalReadingService
                    .updateEndTimeByPatientId(_currentUser!.uid);
              }

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackPage()),
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
