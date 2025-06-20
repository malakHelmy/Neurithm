import 'package:flutter/material.dart';
import 'package:neurithm/l10n/generated/app_localizations.dart';
import 'package:neurithm/models/flagModel.dart';
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

  const ConfirmContextPage(
      {super.key, required this.correctedTexts, required this.sessionId});

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
  String? _flagDocumentId;

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

  Future<void> _handleRegenerate() async {
    if (_selectedText != null) {
      try {
        String aiModelId;

        if (!_regenerationDone) {
          // First time regenerate
          aiModelId = await confirmContextService.getAiModelId('EEGNet');

          // Create FlagModel without correctText
          FlagModel flagModel = FlagModel(
            sessionId: widget.sessionId,
            modelId: aiModelId,
            correctText: null,
          );

          // Save and capture document ID
          _flagDocumentId =
              await confirmContextService.saveFlagAndReturnId(flagModel);
        } else {
          // Subsequent regenerations (EEG Transformer)
          aiModelId =
              await confirmContextService.getAiModelId('EEG Transformer');
          // (no need to save anything for transformer on regenerate)
        }

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
          aiModelId = await confirmContextService.getAiModelId('EEGNet');
        } else {
          aiModelId =
              await confirmContextService.getAiModelId('EEG Transformer');
        }

        await confirmContextService.addPrediction(
          sessionId: widget.sessionId,
          aiModelId: aiModelId,
          predictedText: _selectedText!,
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
    final t = AppLocalizations.of(context)!;
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, color: Color(0xFF1A2A3A), size: 20),
                        SizedBox(width: 5),
                        Text(
                          t.regenerate,
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
                        : () {
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.volume_up,
                            color: Color(0xFF1A2A3A), size: 20),
                        SizedBox(width: 5),
                        Text(
                          t.recite,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    t.finish,
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
                        SizedBox(height: spacing(50, getScreenHeight(context))),
                        Text(
                          t.chooseCorrectionLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Lato',
                            color: Colors.white,
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
                                  onPressed: () async {
                                    setState(() {
                                      _selectedText =
                                          widget.correctedTexts[index];
                                    });

                                    if (_regenerationDone &&
                                        _flagDocumentId != null) {
                                      await confirmContextService
                                          .updateFlagCorrectText(
                                        documentId: _flagDocumentId!,
                                        correctText: _selectedText!,
                                      );
                                    }
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
                        SizedBox(height: spacing(10, getScreenHeight(context))),
                        _actionButtons(),
                        SizedBox(height: spacing(40, getScreenHeight(context))),
                        if (_regenerationDone) ...[
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Didn't find the right sentence? Press regenerate or write your own version below:",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Rephrase it...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _selectedText = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _selectedText == null
                                ? null
                                : () async {
                                    await _handleRecite();

                                    // Save FlagModel for EEGNet
                                    String eegNetModelId =
                                        await confirmContextService
                                            .getAiModelId('EEGNet');
                                    FlagModel eegNetFlag = FlagModel(
                                      sessionId: widget.sessionId,
                                      modelId: eegNetModelId,
                                      correctText: _selectedText,
                                    );
                                    await confirmContextService
                                        .saveFlag(eegNetFlag);

                                    // Save FlagModel for EEG Transformer
                                    String transformerModelId =
                                        await confirmContextService
                                            .getAiModelId('EEG Transformer');
                                    FlagModel transformerFlag = FlagModel(
                                      sessionId: widget.sessionId,
                                      modelId: transformerModelId,
                                      correctText: _selectedText,
                                    );
                                    await confirmContextService
                                        .saveFlag(transformerFlag);
                                  },
                            icon: Icon(Icons.volume_up, color: Colors.white),
                            label: Text(
                              "Recite",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1A2A3A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      spacing(12, getScreenHeight(context))),
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
