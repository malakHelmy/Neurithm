import 'package:flutter/material.dart';
import 'package:neurithm/models/wordBank.dart';
import 'package:neurithm/models/wordBankCategories.dart';
import 'package:neurithm/services/wordBankService.dart';

class WordBankPhrases extends StatefulWidget {
  final WordBankCategory category;
  const WordBankPhrases({super.key, required this.category});

  @override
  State<WordBankPhrases> createState() => _PhrasesPageState();
}

class _PhrasesPageState extends State<WordBankPhrases> {
  final WordBankService _wordBankService = WordBankService();
  List<WordBankPhrase> phrases = [];
  bool isLoading = true;
  Map<String, int> phraseClicks = {}; // Track phrase clicks

  @override
  void initState() {
    super.initState();
    _fetchPhrases();
  }

  Future<void> _fetchPhrases() async {
    try {
      final fetchedPhrases = await _wordBankService.fetchPhrases(widget.category.id);
      setState(() {
        phrases = fetchedPhrases;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching phrases: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handlePhraseClick(WordBankPhrase phrase) async {
    // Increment click count
    setState(() {
      phraseClicks[phrase.id] = (phraseClicks[phrase.id] ?? 0) + 1;
    });

    // If clicked more than 3 times, move to "Frequent used phrases"
    if (phraseClicks[phrase.id]! >= 3) {
      await _addToFrequentUsedPhrases(phrase);
    }
  }

  Future<void> _addToFrequentUsedPhrases(WordBankPhrase phrase) async {
    try {
      // Fetch the ID of "Frequent used phrases" category
      final frequentCategoryId = await _wordBankService.getCategoryId("Frequent Used Phrases");

      // Add the phrase to the "Frequent used phrases" category
      await _wordBankService.addPhraseToCategory(phrase, frequentCategoryId);

      print("Phrase '${phrase.phrase}' added to Frequent Used Phrases");
    } catch (e) {
      print("Error adding phrase to Frequent Used Phrases: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: phrases.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(phrases[index].phrase, style: const TextStyle(fontSize: 24)),
                  leading: const Icon(Icons.chat),
                  onTap: () => _handlePhraseClick(phrases[index]), // Track clicks
                );
              },
            ),
    );
  }
}
