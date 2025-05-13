import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neurithm/models/feedback.dart';
import 'package:neurithm/models/locale.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a single feedback entry to Firestore
  Future<void> addFeedback(FeedbackModel feedback) async {
    var feedbackRef = _db.collection('feedback').doc();
    await feedbackRef.set(feedback.toMap());
  }

  Future<void> addArabicPredefinedFeedback() async {
    List<Map<String, String>> predefinedFeedback = [
      {"category": "اتصال السماعة", "comment": "سهولة الاتصال"},
      {"category": "اتصال السماعة", "comment": "انقطاعات متكررة"},
      {"category": "اتصال السماعة", "comment": "استغرق وقتًا طويلاً للاتصال"},
      {"category": "مخرجات النص", "comment": "وقت استجابة بطيء"},
      {"category": "مخرجات النص", "comment": "فهم المقصد جيدًا"},
      {"category": "مخرجات النص", "comment": "إعادة توليد النص مرات كثيرة"},
      {"category": "مخرجات النص", "comment": "إعادة التوليد لا تحسن الدقة"},
      {"category": "مخرجات النص", "comment": "إعادة التوليد كانت مفيدة"},
      {"category": "مخرجات النص", "comment": "كشف الكلمات بدقة"},
      {"category": "أداء تحويل النص إلى كلام", "comment": "الصوت بدا آليًا"},
      {
        "category": "أداء تحويل النص إلى كلام",
        "comment": "الصوت كان رتيبًا جدًا"
      },
      {"category": "أداء تحويل النص إلى كلام", "comment": "صوت واضح وطبيعي"},
      {
        "category": "واجهة المستخدم وسهولة الاستخدام",
        "comment": "سهولة التنقل"
      },
      {
        "category": "واجهة المستخدم وسهولة الاستخدام",
        "comment": "سلس وسريع الاستجابة"
      },
      {"category": "واجهة المستخدم وسهولة الاستخدام", "comment": "معقد جدًا"},
      {
        "category": "واجهة المستخدم وسهولة الاستخدام",
        "comment": "يحتاج إلى تخطيط أفضل"
      },
      {"category": "بنك الكلمات والعبارات", "comment": "اختيار مفيد للعبارات"},
      {
        "category": "بنك الكلمات والعبارات",
        "comment": "يحتاج إلى المزيد من فئات الكلمات"
      },
      {
        "category": "بنك الكلمات والعبارات",
        "comment": "لا يوجد ما يكفي من العبارات في كل فئة"
      },
      {"category": "بنك الكلمات والعبارات", "comment": "مفيد للتواصل السريع"},
    ];

    for (var feedback in predefinedFeedback) {
      print("adding arabic feedback");
      var feedbackRef = _db.collection('ar_feedback').doc();
      await feedbackRef.set({
        'category': feedback['category'],
        'comment': feedback['comment'],
      });
    }
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
  Future<List<String>> fetchCategories(BuildContext context) async {
    try {
      LocaleModel localeModel =
          Provider.of<LocaleModel>(context, listen: false);
      String languageCode = localeModel.locale.languageCode;
      String collectionName = languageCode == 'ar' ? 'ar_feedback' : 'feedback';

      var querySnapshot = await _db.collection(collectionName).get();
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
  Future<List<String>> fetchCommentsByCategory(
      String category, BuildContext context) async {
    try {
      LocaleModel localeModel =
          Provider.of<LocaleModel>(context, listen: false);
      String languageCode = localeModel.locale.languageCode;
      String collectionName = languageCode == 'ar' ? 'ar_feedback' : 'feedback';

      var querySnapshot = await _db
          .collection(collectionName)
          .where('category', isEqualTo: category)
          .get();

      return querySnapshot.docs.map((doc) => doc['comment'] as String).toList();
    } catch (e) {
      print("Error fetching comments for category '$category': $e");
      return [];
    }
  }

  // Fetch all feedback comments
  Future<List<Map<String, dynamic>>> aggregateFeedbacks() async {
    // Get both English and Arabic feedback collections
    final enFeedbackQuery = await _db.collection('feedback').get();
    final arFeedbackQuery = await _db.collection('ar_feedback').get();
    final patientFeedbackQuery = await _db.collection('patient_feedback').get();
    final patientQuery = await _db.collection('patients').get();

    // Combine all feedback documents
    final allFeedbackDocs = [...enFeedbackQuery.docs, ...arFeedbackQuery.docs];

    Map<String, Set<DateTime>> uniqueFeedbacks = {};
    Map<String, Map<DateTime, List<String>>> feedbackComments = {};
    List<Map<String, dynamic>> aggregatedFeedbackList = [];

    for (var feedbackDoc in patientFeedbackQuery.docs) {
      final feedbackData = feedbackDoc.data();
      final patientId = feedbackData['patientId'];
      final feedbackId = feedbackData['feedbackId'];
      final submittedAt = feedbackData['submittedAt'] is Timestamp
          ? (feedbackData['submittedAt'] as Timestamp).toDate()
          : DateTime.parse(feedbackData['submittedAt']);

      final isResolved = feedbackData['isResolved'] ?? false;
      if (isResolved) continue;

      uniqueFeedbacks.putIfAbsent(patientId, () => {}).add(submittedAt);
      feedbackComments.putIfAbsent(patientId, () => {});
      feedbackComments[patientId]!.putIfAbsent(submittedAt, () => []);

      // Search in combined feedback docs
      final matchingFeedback =
          allFeedbackDocs.where((doc) => doc.id == feedbackId);
      if (matchingFeedback.isNotEmpty) {
        feedbackComments[patientId]![submittedAt]!
            .add(matchingFeedback.first['comment']);
      }
    }

    for (var patientId in uniqueFeedbacks.keys) {
      final user = patientQuery.docs.firstWhere(
        (doc) => doc.id == patientId,
        orElse: () => throw Exception('Patient not found'),
      );
      final fullName = "${user['firstName']} ${user['lastName']}";

      for (var date in uniqueFeedbacks[patientId]!) {
        aggregatedFeedbackList.add({
          'userName': fullName,
          'date': date,
          'comments': feedbackComments[patientId]![date]!.join(', '),
          'feedbackIds': feedbackComments[patientId]![date]!,
          'isResolved': false,
        });
      }
    }

    return aggregatedFeedbackList;
  }

  // Resolve feedback by updating the Firestore document
  Future<void> markAsResolved(String userName, dynamic date) async {
    DateTime firebaseDate =
        date is String ? DateTime.parse(date) : date as DateTime;

    final nameParts = userName.split(' ');
    final firstName = nameParts[0];
    final lastName = nameParts.sublist(1).join(' ');

    final patientQuery = await _db
        .collection('patients')
        .where('firstName', isEqualTo: firstName)
        .where('lastName', isEqualTo: lastName)
        .get();

    if (patientQuery.docs.isEmpty) return;

    final patientId = patientQuery.docs.first.id;

    final feedbacks = await FirebaseFirestore.instance
        .collection('patient_feedback')
        .where('patientId', isEqualTo: patientId)
        .get();

    for (var doc in feedbacks.docs) {
      var submittedAt = doc['submittedAt'] is Timestamp
          ? (doc['submittedAt'] as Timestamp).toDate()
          : DateTime.parse(doc['submittedAt']);

      if (submittedAt.isAtSameMomentAs(firebaseDate)) {
        await doc.reference.update({'isResolved': true});
      }
    }
  }

  // Fetch feedback data and cache it locally
  Future<Map<String, List<String>>> fetchFeedbackDataAndCache(
      BuildContext context) async {
    LocaleModel localeModel = Provider.of<LocaleModel>(context, listen: false);
    String languageCode = localeModel.locale.languageCode;
    String collectionName = languageCode == 'ar' ? 'ar_feedback' : 'feedback';

    final feedbackSnapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();

    Map<String, List<String>> feedbackData = {};

    for (var doc in feedbackSnapshot.docs) {
      final data = doc.data();
      final category = data['category'] ?? 'Uncategorized';
      final comment = data['comment'] ?? '';

      if (!feedbackData.containsKey(category)) {
        feedbackData[category] = [];
      }

      feedbackData[category]!.add(comment);
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cached_feedback', jsonEncode(feedbackData));

    return feedbackData;
  }

  // Patient submits feedback after end of session
  Future<void> submitFeedback({
    required Set<String> selectedComments,
    required Map<String, List<String>> feedbackData,
    required String patientId,
    required BuildContext context,
  }) async {
    if (selectedComments.isEmpty || patientId.isEmpty) return;

    LocaleModel localeModel = Provider.of<LocaleModel>(context, listen: false);
    String languageCode = localeModel.locale.languageCode;
    String collectionName = languageCode == 'ar' ? 'ar_feedback' : 'feedback';

    final today = DateTime.now();
    final feedbackCollection =
        FirebaseFirestore.instance.collection(collectionName);
    final patientFeedbackCollection =
        FirebaseFirestore.instance.collection('patient_feedback');

    for (var comment in selectedComments) {
      final category = feedbackData.keys.firstWhere(
        (key) => feedbackData[key]!.contains(comment),
        orElse: () => 'Unknown',
      );

      final querySnapshot =
          await feedbackCollection.where('comment', isEqualTo: comment).get();

      if (querySnapshot.docs.isNotEmpty) {
        final feedbackId = querySnapshot.docs.first.id;
        await patientFeedbackCollection.add({
          'patientId': patientId,
          'feedbackId': feedbackId,
          'submittedAt': today.toIso8601String(),
          'isResolved': false,
        });
      }
    }
  }

  Future<void> submitHelp({
    required String comment,
    required String patientId,
  }) async {
    if (comment.isEmpty || patientId.isEmpty) return;

    final today = DateTime.now();
    final patientCommentsCollection =
        FirebaseFirestore.instance.collection('patient_comments');

    await patientCommentsCollection.add({
      'patientId': patientId,
      'comment': comment,
      'submittedAt': today.toIso8601String(),
      'isResolved': false,
    });
  }
}
