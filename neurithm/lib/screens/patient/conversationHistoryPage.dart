import 'package:flutter/material.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/bottomBar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';
import 'package:neurithm/services/conversationHistoryService.dart';
import 'package:neurithm/services/authService.dart';
import 'package:neurithm/models/patient.dart';
import 'package:intl/intl.dart'; // To format date/time

class ConversationHistoryPage extends StatefulWidget {
  const ConversationHistoryPage({super.key});

  @override
  State<ConversationHistoryPage> createState() =>
      _ConversationHistoryPageState();
}

class _ConversationHistoryPageState extends State<ConversationHistoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _authService = AuthService();
  final ConversationHistoryService _conversationHistoryService =
      ConversationHistoryService();

  Patient? _currentUser;
  List<Map<String, String>> _conversationHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchUserAndHistory();
  }

  Future<void> _fetchUserAndHistory() async {
    Patient? user = await _authService.getCurrentUser();
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
      List<Map<String, String>> history =
          await _conversationHistoryService.fetchConversationHistory(user.uid);
      setState(() {
        _conversationHistory = history;
      });
    }
  }

  // Function to format DateTime
  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Function to format time (HH:mm)
  String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize(double size) => size * screenWidth / 400;
    double spacing(double size) => size * screenHeight / 800;

    return Scaffold(
      key: _scaffoldKey,
      drawer: sideAppBar(context),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(spacing(5)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: BottomBar(context),
        ),
      ),
      body: Container(
        decoration: gradientBackground,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.50,
                child: Image.asset(
                  'assets/images/waves.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appBar(_scaffoldKey),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Scrollable content area for conversation history
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _conversationHistory.length,
                          itemBuilder: (context, index) {
                            final history = _conversationHistory[index];
                            final date = history['date'] ?? '';
                            final content = history['content'] ?? '';

                            // Split the date into start and end time
                            List<String> dateRange = date.split(" - ");
                            DateTime startTime = DateTime.parse(dateRange[0]);
                            DateTime endTime = dateRange.length > 1
                                ? DateTime.parse(dateRange[1])
                                : DateTime.now();

                            return Card(
                              color: Colors.transparent,
                              margin: EdgeInsets.symmetric(vertical: spacing(8)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(spacing(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Session Details: No box around it, just clean text
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Session Date: ${formatDate(startTime)}',
                                          style: TextStyle(
                                            fontSize: fontSize(16),
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: spacing(5)),
                                        Text(
                                          'Start Time: ${formatTime(startTime)}',
                                          style: TextStyle(
                                            fontSize: fontSize(14),
                                            color: Colors.white54,
                                          ),
                                        ),
                                        SizedBox(height: spacing(5)),
                                        Text(
                                          'End Time: ${formatTime(endTime)}',
                                          style: TextStyle(
                                            fontSize: fontSize(14),
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: spacing(15)),
                                    // Prediction Text Box Styling
                                    Container(
                                      padding: EdgeInsets.all(spacing(12)),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        content,
                                        style: TextStyle(
                                          fontSize: fontSize(18),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
