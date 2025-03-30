import 'package:flutter/material.dart';
import 'package:neurithm/models/wordBankCategories.dart';
import 'package:neurithm/screens/feedbackScreen.dart';
import 'package:neurithm/widgets/wordBankPhrases.dart';
import '../widgets/appBar.dart';
import '../widgets/wavesBackground.dart';
import 'homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/confirmationPage.dart';
import '../widgets/wordBankPhrases.dart'; // Make sure this import exists

class Signalreadingpage extends StatelessWidget {
  const Signalreadingpage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: gradientBackground,
        child: Stack(
          children: [
            wavesBackground(getScreenWidth(context), getScreenHeight(context)),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: spacing(15, getScreenHeight(context))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Processing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Lato',
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Text(
                      'Reading and analyzing your signal data',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lato',
                      ),
                    ),
                    SizedBox(height: spacing(25, getScreenHeight(context))),

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF1A2A3A),
                          ),
                          strokeWidth: 4,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Categories - horizontal scrollable
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('word_bank_categories')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }

                        final docs = snapshot.data!.docs;

                        if (docs.isEmpty) {
                          return const Text('No categories found');
                        }

                        return Container(
                          height: 42,
                          margin: const EdgeInsets.only(top: 10, bottom: 5),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: docs.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final doc = docs[index];
                              final category = WordBankCategory(
                                id: doc.id,
                                name: doc['name'] ?? 'Unnamed',
                              );

                              return ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WordBankPhrases(category: category),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 240, 240, 240),
                                  foregroundColor: const Color(0xFF1A2A3A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  minimumSize: const Size(0, 36),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF1A2A3A),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom action buttons
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(Icons.play_arrow, 'Start Thinking',
                            () {
                          // Start Thinking logic
                        }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _actionButton(
                            Icons.check_circle, 'Done Thinking', () async {
                          final User? user = FirebaseAuth.instance.currentUser;
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No user is logged in.'),
                              ),
                            );
                            return;
                          }

                          final String userId = user.uid;
                          final sessionsQuery = await FirebaseFirestore.instance
                              .collection('session')
                              .where('patientId', isEqualTo: userId)
                              .get();

                          if (sessionsQuery.docs.isNotEmpty) {
                            final sessionId = sessionsQuery.docs.first.id;
                            final predictionsQuery = await FirebaseFirestore
                                .instance
                                .collection('predictions')
                                .where('sessionId', isEqualTo: sessionId)
                                .get();

                            if (predictionsQuery.docs.isNotEmpty) {
                              final predictedText =
                                  predictionsQuery.docs.first['predictedText'];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConfirmationPage(
                                    processedSentence: predictedText,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No prediction found.'),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No session found.'),
                              ),
                            );
                          }
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                            Icons.skip_next, 'Move to Next Word', () {
                          // Move to next word logic
                        }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _actionButton(Icons.restart_alt, 'Restart', () {
                          // Restart logic
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        foregroundColor: const Color(0xFF1A2A3A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF1A2A3A),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
