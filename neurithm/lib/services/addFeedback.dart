import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neurithm/models/feedback.dart';

class FeedbackService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a single feedback entry to Firestore
  Future<void> addFeedback(FeedbackModel feedback) async {
    var feedbackRef = _db.collection('feedback').doc();
    await feedbackRef.set(feedback.toMap());
  }

  // Add predefined feedback comments to Firestore
  Future<void> addPredefinedFeedback() async {
    List<Map<String, String>> predefinedFeedback = [
      {"category": "Headset Connection", "comment": "Easy to connect"},
      {"category": "Headset Connection", "comment": "Frequent disconnections"},
      {"category": "Headset Connection", "comment": "Took too long to connect"},
      {"category": "Text Output", "comment": "Slow response time"},
      {"category": "Text Output", "comment": "Captured my intent well"},
      {"category": "Text Output", "comment": "Too many text regenerations"},
      {
        "category": "Text Output",
        "comment": "Regenerations don’t improve accuracy"
      },
      {"category": "Text Output", "comment": "Regeneration was useful"},
      {"category": "Text Output", "comment": "Accurate word detection"},
      {
        "category": "Text to Speech Performance",
        "comment": "Speech sounded robotic"
      },
      {
        "category": "Text to Speech Performance",
        "comment": "Voice was too monotone"
      },
      {
        "category": "Text to Speech Performance",
        "comment": "Clear and natural voice"
      },
      {"category": "Interface & Usability", "comment": "Easy to navigate"},
      {"category": "Interface & Usability", "comment": "Smooth and responsive"},
      {"category": "Interface & Usability", "comment": "Too complicated"},
      {"category": "Interface & Usability", "comment": "Needs better layout"},
      {"category": "Word Bank & Phrases", "comment": "Useful phrase selection"},
      {
        "category": "Word Bank & Phrases",
        "comment": "Needs more word categories"
      },
      {
        "category": "Word Bank & Phrases",
        "comment": "Not enough phrases in each category"
      },
      {
        "category": "Word Bank & Phrases",
        "comment": "Helpful for quick communication"
      },
    ];

    for (var feedback in predefinedFeedback) {
      var feedbackRef = _db.collection('feedback').doc();
      await feedbackRef.set({
        'category': feedback['category'],
        'comment': feedback['comment'],
      });
    }
  }

  // Fetch distinct feedback categories
  Future<List<String>> fetchCategories() async {
    try {
      var querySnapshot = await _db.collection('feedback').get();
      Set<String> categories = {};

      for (var doc in querySnapshot.docs) {
        categories.add(doc['category']);
      }

      return categories.toList();
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

  // Fetch feedback comments by category
  Future<List<String>> fetchCommentsByCategory(String category) async {
    try {
      var querySnapshot = await _db
          .collection('feedback')
          .where('category', isEqualTo: category)
          .get();

      return querySnapshot.docs.map((doc) => doc['comment'] as String).toList();
    } catch (e) {
      print("Error fetching comments for category '$category': $e");
      return [];
    }
  }
}
