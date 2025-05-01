import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neurithm/models/patient.dart';
import 'package:neurithm/models/wordBankCategories.dart';
import 'package:neurithm/services/authService.dart';
import 'package:neurithm/services/signalReadingService.dart'; 
import 'package:neurithm/widgets/appBar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';
import 'package:neurithm/widgets/wordBankPhrases.dart'; 

class SignalReadingpage extends StatefulWidget {
  const SignalReadingpage({super.key});

  @override
  State<SignalReadingpage> createState() => _SignalReadingpageState();
}

class _SignalReadingpageState extends State<SignalReadingpage> {
  final AuthService _authService = AuthService();
  final SignalReadingService signalReadingService = SignalReadingService();
  Patient? _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    Patient? user = await _authService.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

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

                    // Word Bank Categories
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
                                      builder: (context) => WordBankPhrases(
                                          currentUser: _currentUser,
                                          category: category),
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
                        child: _actionButton(Icons.play_arrow, 'Start Thinking',() {
                            signalReadingService.uploadFileAndStartThinking(context);  
                          }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _actionButton(
                            Icons.check_circle, 'Done Thinking', () {
                              signalReadingService.doneThinking(context); 
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                            Icons.skip_next, 'Move to Next Word',() {
                            signalReadingService.uploadFileAndStartThinking(context);  
                          }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child:
                            _actionButton(Icons.restart_alt, 'Restart' ,() {
                            signalReadingService.restartServer(context);  
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
