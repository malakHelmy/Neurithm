import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:neurithm/models/feedback.dart';
import 'package:neurithm/models/patient.dart';
import 'package:neurithm/services/addFeedback.dart';
import 'package:neurithm/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/wavesBackground.dart';
import 'homePage.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FeedbackService _feedbackService = FeedbackService();
  final AuthMethods _authMethods = AuthMethods();

  Map<String, List<String>> _feedbackData = {};
  Set<String> _selectedComments = {};
  Patient? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchUser();
    await _loadFeedbackFromCache();
    _fetchFeedbackDataInBackground();
  }

  Future<void> _loadFeedbackFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('cached_feedback');

    if (cached != null) {
      try {
        final decoded = Map<String, dynamic>.from(jsonDecode(cached));
        final loaded = decoded.map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        );

        if (mounted) {
          setState(() {
            _feedbackData = loaded;
            _isLoading = false;
          });
        }
      } catch (e) {
        print("Failed to decode cached feedback: $e");
      }
    }
  }

  Future<void> _fetchFeedbackDataInBackground() async {
    final feedbackSnapshot =
        await FirebaseFirestore.instance.collection('feedback').get();

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

    // ✅ Cache the data locally
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cached_feedback', jsonEncode(feedbackData));

    if (mounted) {
      setState(() {
        _feedbackData = feedbackData;
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUser() async {
    Patient? user = await _authMethods.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  void _submitFeedback() async {
    if (_selectedComments.isEmpty || _currentUser == null) return;

    List<String> feedbackIds = [];
    DateTime today = DateTime.now();

    // Loop through selected comments
    for (var comment in _selectedComments) {
      String category = _feedbackData.keys.firstWhere(
        (key) => _feedbackData[key]!.contains(comment),
        orElse: () => "Unknown",
      );

      // Query the 'feedback' collection to get the feedback ID for the existing comment
      var querySnapshot = await FirebaseFirestore.instance
          .collection('feedback')
          .where('comment', isEqualTo: comment)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        feedbackIds.add(querySnapshot.docs.first.id);
      }
    }

    // Now we only create entries in 'patient_feedback' using the feedbackId
    for (var feedbackId in feedbackIds) {
      await FirebaseFirestore.instance.collection('patient_feedback').add({
        'patientId': _currentUser?.uid,
        'feedbackId': feedbackId,
        'submittedAt': today.toIso8601String(),
        'isResolved': false,
      });
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int openCount = prefs.getInt('open_count') ?? 0;
    print("Current openCount: $openCount");

    openCount++;
    await prefs.setInt('open_count', openCount);

    print("Updated openCount: $openCount");

    bool showRatingPopup = (openCount % 3 == 0);

    print("Show rating popup: $showRatingPopup");

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(showRatingPopup: showRatingPopup),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Session Feedback"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            SystemUiOverlayStyle.light, // Ensure status bar is light-themed
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: wavesBackground(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: MediaQuery.of(context).padding.top +
                  kToolbarHeight, // ✅ Fixes AppBar overlapping
              bottom: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _feedbackData.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            Wrap(
                              spacing: 10.0,
                              runSpacing: 10.0,
                              children: entry.value.map((comment) {
                                bool isSelected =
                                    _selectedComments.contains(comment);
                                return ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isSelected
                                          ? _selectedComments.remove(comment)
                                          : _selectedComments.add(comment);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isSelected
                                        ? const Color(0xFF1A2A3A)
                                        : const Color.fromARGB(
                                            255, 206, 206, 206),
                                    foregroundColor: isSelected
                                        ? Colors.white70
                                        : Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 24),
                                  ),
                                  child: Text(comment,
                                      textAlign: TextAlign.center),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 15),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(showRatingPopup: false))),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Skip", style: TextStyle(fontSize: 18)),
                    ),
                    ElevatedButton(
                      onPressed:
                          _selectedComments.isNotEmpty ? _submitFeedback : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A2A3A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child:
                          const Text("Submit", style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
