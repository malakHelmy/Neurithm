import 'package:flutter/material.dart';
import 'package:neurithm/widgets/appBar.dart';
import 'package:neurithm/widgets/bottomBar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';

class ConversationHistoryPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // dummy DATA
  final List<Map<String, String>> conversationHistory = [
    {
      'date': '2024-11-13',
      'content': 'I would like a smokey cheese pizza please.'
    },
    {'date': '2024-11-12', 'content': 'I am going for a walk.'},
    {'date': '2024-11-11', 'content': 'Lets go to the movies.'},
    {'date': '2024-11-10', 'content': 'Thank you.'},
  ];

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
                          itemCount: conversationHistory.length,
                          itemBuilder: (context, index) {
                            final history = conversationHistory[index];
                            return Card(
                              color: const Color.fromARGB(255, 29, 29, 29)
                                  .withOpacity(0.15),
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
                                    Text(
                                      history['date'] ?? '',
                                      style: TextStyle(
                                        fontSize: fontSize(15),
                                        color: Colors.white54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: spacing(5)),
                                    Text(
                                      history['content'] ?? '',
                                      style: TextStyle(
                                        fontSize: fontSize(20),
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
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
