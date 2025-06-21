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
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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
    Future<void> _handleRegenerate() async {
      try {
        setState(() {
          _isRegenerating = true;
        });

        var response = await http.post(
          Uri.parse('https://62c5-45-243-241-52.ngrok-free.app/regenerate'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'num_options': 5,
          }),
        );

        if (response.statusCode == 200) {
          var data = json.decode(response.body);

          // Extract the corrected texts from the response
          List<String> correctedTexts =
              List<String>.from(data['corrected_texts']);
          print("Corrected texts: $correctedTexts");

          // Update the UI to show the corrected texts
          setState(() {
            widget.correctedTexts.clear();
            widget.correctedTexts.addAll(correctedTexts);
            _regenerationDone = true;
          });
        } else {
          print("Failed to regenerate: ${response.statusCode}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(t.regenerationFailed),
          ));
        }
      } catch (e) {
        print("Error occurred: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
        ));
      } finally {
        setState(() {
          _isRegenerating = false;
        });
      }
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
                          style: const TextStyle(
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
                        const Icon(Icons.volume_up,
                            color: Color(0xFF1A2A3A), size: 20),
                        const SizedBox(width: 5),
                        Text(
                          t.recite,
                          style: const TextStyle(
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
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            t.chooseCorrectionLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              fontFamily: 'Lato',
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: gradientBackground,
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: getScreenWidth(context) / getScreenHeight(context),
              child: Opacity(
                opacity: 0.30,
                child: Image.asset(
                  'assets/images/waves.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing(15, getScreenHeight(context)),
                ),
                child: _isRegenerating
                    ?  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            t.regenerating,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            // Display all corrected text options
                            SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.correctedTexts.length,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
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
                                            ? const Color.fromARGB(
                                                255, 148, 206, 253)
                                            : Colors.white,
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                            SizedBox(
                                height: spacing(10, getScreenHeight(context))),
                            _actionButtons(),
                            SizedBox(
                                height: spacing(10, getScreenHeight(context))),
                            if (_regenerationDone) ...[
                               Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  t.customSentenceInstruction,
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
                                  style: TextStyle(color: Color(0xFF1A2A3A)),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: t.rephraseHint,
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Color(0xFF1A2A3A))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFF1A2A3A)))),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedText = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 15),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
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
                                                  .getAiModelId(
                                                      'EEG Transformer');
                                          FlagModel transformerFlag = FlagModel(
                                            sessionId: widget.sessionId,
                                            modelId: transformerModelId,
                                            correctText: _selectedText,
                                          );
                                          await confirmContextService
                                              .saveFlag(transformerFlag);
                                        },
                                  icon: Icon(Icons.volume_up,
                                      color: Colors.white),
                                  label: Text(
                                    t.reciteThisSentence,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF1A2A3A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: spacing(
                                            12, getScreenHeight(context))),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
