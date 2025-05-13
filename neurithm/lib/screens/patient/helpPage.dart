import 'package:flutter/material.dart';
import 'package:neurithm/l10n/generated/app_localizations.dart';
import 'package:neurithm/models/patient.dart';
import 'package:neurithm/screens/patient/connectionTutorialPage.dart';
import 'package:neurithm/services/authService.dart';
import 'package:neurithm/services/patientProfileService.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/bottomBar.dart';
import 'package:neurithm/widgets/customTextField.dart';
import 'package:neurithm/widgets/wavesBackground.dart';
import 'package:neurithm/widgets/faqTiles.dart';
import 'package:neurithm/services/feedbackService.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final FeedbackService _feedbackService = FeedbackService();
  final PatientProfileService _profileService = PatientProfileService();
  final AuthService _authService = AuthService();

  late String comment;
  Patient? _currentUser;
  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    Patient? user = await _authService.getCurrentUser();
    if (user != null) {
      final data = await _profileService.fetchPatientData(user.uid);
      if (mounted && data != null) {
        setState(() {
          _currentUser = user;
          nameController.text =
              data['firstName'] + ' ' + data['lastName'] ?? '';
          emailController.text = data['email'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    void _submitComment(BuildContext context) async {
      if (_currentUser == null) return;
      final commentText = commentController.text.trim();
      if (commentText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Comment/Message cannot be empty'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        return;
      }
      try {
        await _feedbackService.submitHelp(
          comment: commentController.text,
          patientId: _currentUser!.uid,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.submitSuccess),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.submitFailure),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      drawer: sideAppBar(context),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(
          spacing(5, getScreenHeight(context)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: BottomBar(context, 0),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: gradientBackground,
          child: Stack(
            children: [
              waveBackground,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing(15, getScreenHeight(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drawer AppBar
                    appBar(_scaffoldKey),

                    SizedBox(height: spacing(15, getScreenHeight(context))),

                    Text(
                      t.helpTitle,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      t.helpSubtitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white70,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: nameController,
                            readOnly: true,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                            decoration: customTextField(t.fullNameLabel),
                            // validator: _validateEmail,
                          ),
                          TextFormField(
                            controller: emailController,
                            readOnly: true,

                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                            decoration: customTextField(t.emailLabel),
                            // validator: _validateEmail,
                          ),
                          TextFormField(
                              controller: commentController,
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                              decoration: customTextField(t.commentLabel)
                              // validator: _validateAge,
                              ),

                          const SizedBox(height: 30),

                          // Sign In Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _submitComment(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                t.submit,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF1A2A3A),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Sign in with Google Button
                        ],
                      ),
                    ),
                    SizedBox(height: spacing(25, getScreenHeight(context))),
                    Text(
                      t.faqTitle,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: spacing(20, getScreenHeight(context))),

                    // FAQ Section
                    FAQSection(),

                    SizedBox(height: spacing(20, getScreenHeight(context))),

                    // Tutorial Button
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to tutorial page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TutorialPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 240, 240, 240),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    spacing(13, getScreenHeight(context))),
                          ),
                          child: Text(
                            t.goToTutorial,
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF1A2A3A),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: spacing(20, getScreenHeight(context))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
