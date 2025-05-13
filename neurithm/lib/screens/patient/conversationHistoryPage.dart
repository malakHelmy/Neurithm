import 'package:flutter/material.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/bottomBar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';
import 'package:neurithm/services/conversationHistoryService.dart';
import 'package:neurithm/services/authService.dart';
import 'package:neurithm/models/patient.dart';
import 'package:intl/intl.dart';

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

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  // Delete individual prediction
  void _deletePrediction(String predictionId) async {
    await _conversationHistoryService.deletePrediction(predictionId);
    setState(() {
      _fetchUserAndHistory();
    });
  }

  // Delete entire session
  void _deleteSession(String sessionId) async {
    await _conversationHistoryService.deleteSession(sessionId);
    setState(() {
      _fetchUserAndHistory();
    });
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
          child: BottomBar(context, 3),
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
                            final sessionId = history['sessionId'] ?? '';
                            final predictionId = history['predictionId'] ?? '';

                            // Split the date into start and end time
                            List<String> dateRange = date.split(" - ");
                            DateTime startTime = DateTime.parse(dateRange[0]);
                            DateTime endTime = dateRange.length > 1
                                ? DateTime.parse(dateRange[1])
                                : DateTime.now();

                            return Card(
                              color: Colors.transparent,
                              margin:
                                  EdgeInsets.symmetric(vertical: spacing(8)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(spacing(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Session Date: ${formatDate(startTime)}',
                                              style: TextStyle(
                                                fontSize: fontSize(16),
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              
                                            ),IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            _deletePrediction(predictionId);
                                          },
                                        ),
                                          ],
                                        ),
                                        SizedBox(height: spacing(5)),
                                        Text(
                                          content,
                                          style: TextStyle(
                                            fontSize: fontSize(18),
                                            color: Colors.white,
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
                                    
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.end,
                                    //   children: [
                                    //     IconButton(
                                    //       icon: const Icon(
                                    //         Icons.delete_forever,
                                    //         color: Colors.red,
                                    //       ),
                                    //       onPressed: () {
                                    //         _deleteSession(sessionId);
                                    //       },
                                    //     ),
                                    //   ],
                                    // ),
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
