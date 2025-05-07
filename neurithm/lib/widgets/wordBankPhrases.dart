import 'package:flutter/material.dart';
import 'package:neurithm/helpers/phraseTrackerDbHelper.dart';
import 'package:neurithm/models/patient.dart';
import 'package:neurithm/models/voiceSettings.dart';
import 'package:neurithm/models/wordBank.dart';
import 'package:neurithm/models/wordBankCategories.dart';
import 'package:neurithm/models/userPreferences.dart';
import 'package:neurithm/services/wordBankService.dart';
import 'package:neurithm/services/ttsService.dart'; // Import the TTS service
import 'package:just_audio/just_audio.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';

class WordBankPhrases extends StatefulWidget {
  final WordBankCategory category;
  final Patient? currentUser;

  const WordBankPhrases(
      {super.key, required this.currentUser, required this.category});

  @override
  State<WordBankPhrases> createState() => _PhrasesPageState();
}

class _PhrasesPageState extends State<WordBankPhrases> {
  final _audioPlayer = AudioPlayer();

  final WordBankService _wordBankService = WordBankService();
  List<WordBankPhrase> phrases = [];
  bool isLoading = true;
  Map<String, int> phraseClicks = {}; // Track phrase clicks
  final PhraseTrackerDbHelper _phraseTrackerDbHelper =
      PhraseTrackerDbHelper.instance;

  final TTSService _ttsService = TTSService(); // Initialize TTSService

  @override
  void initState() {
    super.initState();
    _fetchPhrases(context);
  }

  Future<void> _fetchPhrases(BuildContext context) async {
    try {
      if (widget.category.name == "Frequent Used Phrases") {
        final fetchedPhrases = await _phraseTrackerDbHelper
            .getFrequentPhrases(widget.currentUser!.uid);
        setState(() {
          phrases = fetchedPhrases;
          isLoading = false;
        });
      } else {
        final fetchedPhrases =
            await _wordBankService.fetchPhrases(widget.category.id, context);
        setState(() {
          phrases = fetchedPhrases;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching phrases: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _trackPhraseClick(String phraseID) async {
    await _phraseTrackerDbHelper.incrementPhraseUsage(
        widget.currentUser!.uid, phraseID);
  }

  Future<void> _playPhraseAudio(String phrase) async {
    String? audioFilePath = await _ttsService.synthesizeSpeech(phrase);
    VoiceSettings settings = await UserPreferences.loadVoiceSettings();
    if (audioFilePath != "error") {
      await _audioPlayer.setPitch(settings.pitch);
      await _audioPlayer.setFilePath(audioFilePath!);
      await _audioPlayer.play();
      print("Audio file path: $audioFilePath");
      // Add audio playing logic here, for example using the `audioplayers` package
    } else {
      print("Failed to synthesize speech.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          waveBackground,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppBar(
              title: Text(widget.category.name),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Color.fromARGB(255, 206, 206, 206)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: spacing(80, getScreenHeight(context))),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : phrases.isEmpty
                    ? const Center(
                        child: Text("No frequently used phrases found."))
                    : ListView.builder(
                        itemCount: phrases.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.chat),
                                title: Row(
                                  children: [
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        phrases[index].phrase,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  await _trackPhraseClick(phrases[index].id);
                                  await _playPhraseAudio(phrases[index].phrase);
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Tracked phrase usage')));
                                },
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Color.fromARGB(255, 148, 148, 148),
                                
                              ),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
