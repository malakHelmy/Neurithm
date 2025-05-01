import 'package:flutter/material.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/loginForm.dart';
import 'package:neurithm/widgets/signUpForm.dart';
import 'package:neurithm/widgets/wavesBackground.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showLoginForm = false;
  bool _showSignUpForm = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize(double size) => size * screenWidth / 400;
    double spacing(double size) => size * screenHeight / 800;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: sideAppBar(context),
      body: Container(
        decoration: darkGradientBackground,
        child: Stack(children: [
          AspectRatio(
            aspectRatio: screenWidth / screenHeight,
            child: Opacity(
              opacity: 0.30,
              child: Image.asset(
                'assets/images/waves.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: _showSignUpForm
                ? screenHeight * 0.15
                : _showLoginForm
                    ? screenHeight * 0.25
                    : screenHeight * 0.35,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing(25)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Neurithm",
                      style: TextStyle(
                        color: Color.fromARGB(255, 206, 206, 206),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Vonique',
                      ),
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedOpacity(
                            opacity:
                                _showLoginForm || _showSignUpForm ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 500),
                            child: _showLoginForm || _showSignUpForm
                                ? const SizedBox.shrink()
                                : Column(
                                    children: [
                                      const Text(
                                        "Where Thoughts Find a Voice",
                                        style: TextStyle(
                                          fontFamily: 'lato',
                                          color: Color.fromARGB(
                                              255, 206, 206, 206),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _showSignUpForm = true;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 240, 240, 240),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: spacing(12)),
                                          ),
                                          child: const Text(
                                            "Get Started",
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.normal,
                                              color: Color(0xFF1A2A3A),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _showLoginForm = true;
                                          });
                                        },
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.normal,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          LoginForm(
                            showLoginForm: _showLoginForm,
                            showSignUpForm: _showSignUpForm,
                            toggleToSignUpForm: () {
                              setState(() {
                                _showSignUpForm = true;
                                _showLoginForm = false;
                              });
                            },
                          ),
                          SignUpForm(
                           showLoginForm: _showLoginForm,
                            showSignUpForm: _showSignUpForm,
                            toggleToLoginForm: () {
                              setState(() {
                                _showLoginForm = true;
                                _showSignUpForm = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}
