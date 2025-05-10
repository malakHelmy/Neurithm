import 'package:flutter/material.dart';
import 'package:neurithm/screens/homepage.dart';
import 'package:neurithm/screens/patient/connectionTutorialPage.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/bottomBar.dart';
import 'package:neurithm/widgets/customTextField.dart';
import 'package:neurithm/widgets/wavesBackground.dart';
import 'package:neurithm/widgets/faqTiles.dart';

class HelpPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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

                    const Text(
                      'Help & Support',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                            decoration: customTextField('Full name'),
                            // validator: _validateEmail,
                          ),
                          TextFormField(
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                            decoration: customTextField('Email'),
                            // validator: _validateEmail,
                          ),
                          TextFormField(
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                              decoration: customTextField(
                                  'Comment or Message')
                              // validator: _validateAge,
                              ),

                          const SizedBox(height: 30),

                          // Sign In Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Your message has been submitted successfully!'),
                                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                                  duration: Duration(seconds: 3),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                "Submit",
                                style: TextStyle(
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
                    const Text(
                      'Frequently Asked Questions',
                      style: TextStyle(
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
                          child: const Text(
                            'Go to Tutorial',
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
