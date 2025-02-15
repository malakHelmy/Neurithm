import 'package:flutter/material.dart';
import 'package:neurithm/models/wordBank.dart';
import 'package:neurithm/models/wordBankCategories.dart';
import 'package:neurithm/services/addwordBank.dart';

class WordBankPhrases extends StatefulWidget {
  final WordBankCategory category;
  const WordBankPhrases({super.key, required this.category});

  @override
  State<WordBankPhrases> createState() => _PhrasesPageState();
}

class _PhrasesPageState extends State<WordBankPhrases> {
  final FirestoreService _firestoreService = FirestoreService();
  List<WordBankPhrase> phrases = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPhrases();
  }

  Future<void> _fetchPhrases() async {
    try {
      final fetchedPhrases = await _firestoreService.fetchPhrases(widget.category.id);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: phrases.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(phrases[index].phrase),
                  leading: Icon(Icons.chat),
                );
              },
            ),
    );
  }
}
