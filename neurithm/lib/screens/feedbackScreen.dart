import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:neurithm/models/feedback.dart';
import 'package:neurithm/models/patient.dart';
import 'package:neurithm/services/addFeedback.dart';
import 'package:neurithm/services/auth.dart';
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
    await _fetchFeedbackData();
  }

  Future<void> _fetchUser() async {
    Patient? user = await _authMethods.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  Future<void> _fetchFeedbackData() async {
    List<String> categories = await _feedbackService.fetchCategories();
    Map<String, List<String>> feedbackData = {};

    for (String category in categories) {
      feedbackData[category] =
          await _feedbackService.fetchCommentsByCategory(category);
    }

    if (mounted) {
      setState(() {
        _feedbackData = feedbackData;
        _isLoading = false;
      });
    }
  }

  void _submitFeedback() async {
    if (_selectedComments.isEmpty || _currentUser == null) return;

    List<String> feedbackIds = [];

    for (var comment in _selectedComments) {
      String category = _feedbackData.keys.firstWhere(
        (key) => _feedbackData[key]!.contains(comment),
        orElse: () => "Unknown",
      );

      var feedbackId =
          FirebaseFirestore.instance.collection('feedback').doc().id;
      await _feedbackService.addFeedback(
        FeedbackModel(id: feedbackId, category: category, comment: comment),
      );
      feedbackIds.add(feedbackId);
    }

    for (var feedbackId in feedbackIds) {
      await FirebaseFirestore.instance.collection('patient_feedback').add({
        'id':
            FirebaseFirestore.instance.collection('patient_feedback').doc().id,
        'patientId': _currentUser?.uid,
        'feedbackId': feedbackId,
      });
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
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
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _feedbackData.entries.map((entry) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
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
                                                ? _selectedComments
                                                    .remove(comment)
                                                : _selectedComments
                                                    .add(comment);
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
                      onPressed: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage())),
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
