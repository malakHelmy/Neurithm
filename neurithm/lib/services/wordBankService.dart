import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neurithm/models/wordBank.dart';
import 'package:neurithm/models/wordBankCategories.dart';

class WordBankService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Upload categories first, then phrases related to each category
  Future<void> uploadCategoriesAndPhrases() async {
    final categories = {
      "food": "Food",
      "work": "Work",
      "family": "Family",
      "emergency": "Emergency",
      "greetings": "Greetings",
      "travel": "Travel",
      "health": "Health",
      "daily_needs": "Daily Needs",
    };

    final phrases = {
      "food": [
        "I'm hungry.",
        "I’m thirsty",
        "I need a drink.",
        "I would like some water.",
        "I’m full, thank you.",
        "Can I have more salt/pepper?",
        "This food is too hot.",
        "I want something sweet.",
        "Can I have something softer to eat?",
        "Please cut my food.",
        "This tastes good.",
        "Can I have a snack?",
        "I need a napkin.",
        "Can you help me with my meal?",
        "Can you give me a straw?"
      ],
      "work": [
        "I need to take a break.",
        "Can you help me respond to emails?",
        "Let’s schedule a meeting.",
        "I’m having difficulty writing.",
        "Please repeat that for me.",
        "Can someone present my work?",
        "Please be patient with me.",
        "Can you assist me with my computer?",
        "Can you clarify this point?",
        "I need assistance with this task",
        "I have completed the assignment.",
        "Let's discuss the project status.",
        "Please send me the report.",
        "Please forward me the email."
      ],
      "family": [
        "I love you.",
        "Can we talk?",
        "I appreciate your support.",
        "Thank you for understanding.",
        "Let's spend time together.",
        "I need some quiet time.",
        "Can you assist me with this?",
        "Can we go outside for fresh air?",
        "Let’s take a picture together.",
        "Please stay with me for a while.",
        "Let’s listen to music together.",
        "Thank you for everything."
      ],
      "emergency": [
        "I can’t breathe well.",
        "Call 911 now!",
        "I feel dizzy.",
        "I’m in pain.",
        "Call my caregiver",
        "I need my medication now.",
        "I feel like I might faint.",
        "Take me to the hospital.",
        "There's a fire.",
        "I have fallen.",
        "Contact my doctor."
      ],
      "greetings": [
        "Hello!",
        "Welcome!",
        "Good morning.",
        "Good afternoon.",
        "Good evening.",
        "How are you?",
        "Nice to see you.",
        "Take care.",
        "See you later.",
        "Have a great day.",
        "Goodbye."
      ],
      "travel": [
        "I need wheelchair assistance.",
        "Where is the nearest restroom?",
        "I need to stretch my legs.",
        "Can you help me find my seat?",
        "This seat is uncomfortable.",
        "Please help me with my bags.",
        "Can we take the elevator?",
        "Where is the nearest exit?",
        "I need assistance boarding.",
        "I have a reservation."
      ],
      "health": [
        "I have an appointment today.",
        "I need to take my medication.",
        "Can you help me with my exercises?",
        "I need to check my blood pressure.",
        "I have a doctor's appointment.",
        "I need to rest now.",
        "Please help me sit up.",
        "Can you help me move my legs?",
        "Can you support my neck?",
        "I need my wheelchair adjusted."
      ],
      "daily_needs": [
        "I need to use the restroom.",
        "Can you help me get dressed?",
        "I need to brush my teeth.",
        "Please assist me with bathing.",
        "I need to charge my device.",
        "Can you help me with my wheelchair?",
        "I need to adjust my position.",
        "Please help me with my glasses.",
        "I need to take a nap.",
        "Can you read to me?",
        "Please set my alarm.",
        "Please help me use my phone.",
        "Please adjust my pillows.",
        "Can you help me wash my hands?",
        "Please bring me my slippers.",
        "I need to take my vitamins.",
        "Can you open the window?"
      ],
    };

    // Upload categories first
    for (var entry in categories.entries) {
      var categoryRef = _db
          .collection('word_bank_categories')
          .doc(); // Create new doc for each category
      await categoryRef.set({'name': entry.value});

      // Upload phrases linked to this category using the document ID of the category
      for (String phrase in phrases[entry.key]!) {
        var phraseRef = _db.collection('word_bank').doc();
        await phraseRef.set({
          'category_id': categoryRef.id, // Link to the category ID
          'phrase': phrase
        });
      }
    }
  }

  // Fetch all categories
  Future<List<WordBankCategory>> fetchCategories() async {
    var querySnapshot = await _db.collection('word_bank_categories').get();
    return querySnapshot.docs
        .map((doc) => WordBankCategory.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Fetch phrases based on category ID
  Future<List<WordBankPhrase>> fetchPhrases(String categoryId) async {
    var querySnapshot = await _db
        .collection('word_bank')
        .where('category_id', isEqualTo: categoryId)
        .get();

    return querySnapshot.docs
        .map((doc) => WordBankPhrase.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<String> getCategoryId(String name) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('word_bank_categories')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      print("category id: " + snapshot.docs.first.id);
      final categoryId = snapshot.docs.first.id;

      return categoryId;
    } else {
      throw Exception("Frequent used phrases category not found");
    }
  }

  Future<void> addPhraseToCategory(
      WordBankPhrase phrase, String categoryId) async {
    await FirebaseFirestore.instance.collection('word_bank').add({
      'phrase': phrase.phrase,
      'category_id': categoryId,
    });
  }
}
