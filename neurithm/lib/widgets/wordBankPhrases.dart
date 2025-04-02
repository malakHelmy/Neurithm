import 'package:flutter/material.dart';
import 'package:neurithm/helpers/phraseTrackerDbHelper.dart';
import 'package:neurithm/models/patient.dart';
import 'package:neurithm/models/wordBank.dart';
import 'package:neurithm/models/wordBankCategories.dart';
import 'package:neurithm/services/wordBankService.dart';

class WordBankPhrases extends StatefulWidget {
  final WordBankCategory category;
  final Patient? currentUser;
  const WordBankPhrases(
      {super.key, required this.currentUser, required this.category});

  @override
  State<WordBankPhrases> createState() => _PhrasesPageState();
}

class _PhrasesPageState extends State<WordBankPhrases> {
  final WordBankService _wordBankService = WordBankService();
  List<WordBankPhrase> phrases = [];
  bool isLoading = true;
  Map<String, int> phraseClicks = {}; // Track phrase clicks
  final PhraseTrackerDbHelper _phraseTrackerDbHelper =
      PhraseTrackerDbHelper.instance;

  @override
  void initState() {
    super.initState();
    _fetchPhrases();
  }

  Future<void> _fetchPhrases() async {
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
            await _wordBankService.fetchPhrases(widget.category.id);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : phrases.isEmpty
              ? Center(child: Text("No frequently used phrases found."))
              : ListView.builder(
                  itemCount: phrases.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(phrases[index].phrase),
                      leading: Icon(Icons.chat),
                      onTap: () async {
                        await _trackPhraseClick(phrases[index].id);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Tracked phrase usage')));
                      },
                    );
                  },
                ),
    );
  }
}
