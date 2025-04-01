import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neurithm/models/patient.dart';
import 'package:neurithm/screens/homepage.dart';
import 'package:neurithm/services/feedbackService.dart';
import 'package:neurithm/services/authService.dart';
import 'package:neurithm/widgets/wavesBackground.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final FeedbackService _feedbackService = FeedbackService();
  final AuthService _authService = AuthService();
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
    _fetchFeedbackDataInBackground();
  }

  Future<void> _fetchFeedbackDataInBackground() async {
    final fetched = await _feedbackService.fetchFeedbackDataAndCache();
    if (mounted) {
      setState(() {
        _feedbackData = fetched;
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUser() async {
    Patient? user = await _authService.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  void _submitFeedback() async {
    if (_currentUser == null) return;

    await _feedbackService.submitFeedback(
      selectedComments: _selectedComments,
      feedbackData: _feedbackData,
      patientId: _currentUser!.uid,
    );

    final prefs = await SharedPreferences.getInstance();
    int openCount = prefs.getInt('open_count') ?? 0;
    openCount++;
    await prefs.setInt('open_count', openCount);

    final showRatingPopup = (openCount % 3 == 0);

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
        systemOverlayStyle: SystemUiOverlayStyle.light,
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
              top: MediaQuery.of(context).padding.top + kToolbarHeight,
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
