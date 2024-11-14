import 'package:flutter/material.dart';
import 'package:neurithm_frontend/widgets/signUpForm.dart';
import '../widgets/appbar.dart';
import '../widgets/wavesBackground.dart';
import '../widgets/loginForm.dart';
import 'homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 15),
            child: loginPageAppBar(_scaffoldKey),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: _showSignUpForm ? 100 : 250, // Move up when form appears
            left: 0,
            right: 0,
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
                  const Text(
                    "Where Thoughts Find a Voice",
                    style: TextStyle(
                      fontFamily: 'lato',
                      color: const Color.fromARGB(255, 206, 206, 206),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Animated opacity for the "Login" and "Create an Account" buttons
                        AnimatedOpacity(
                          opacity:
                              _showLoginForm || _showSignUpForm ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 500),
                          child: _showLoginForm || _showSignUpForm
                              ? const SizedBox
                                  .shrink() // Hide buttons if form is shown
                              : Column(
                                  children: [
                                    SizedBox(
                                      width: screenWidth / 1.5,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _showLoginForm = true;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 240, 240, 240),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: spacing(12)),
                                        ),
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF1A2A3A),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: screenWidth / 1.5,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _showSignUpForm = true;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 240, 240, 240),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: spacing(12)),
                                        ),
                                        child: const Text(
                                          "Create an Account",
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFF1A2A3A),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        // Animated opacity for the login form
                        signUpForm(context, _showLoginForm, _showSignUpForm),
                        AnimatedOpacity(
                          opacity: _showLoginForm ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 600),
                          child: _showLoginForm && _showSignUpForm == false
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Column(
                                    children: [
                                      TextField(
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF1A2A3A)),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 14, vertical: 13),
                                          hintText: "Username",
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        obscureText: true,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF1A2A3A)),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 14, vertical: 13),
                                          hintText: "Password",
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(),
                                                ));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF1A2A3A),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                          ),
                                          child: const Text(
                                            "Log In",
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Color.fromARGB(
                                                  255, 252, 254, 255),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 190,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Dont have an account?',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _showSignUpForm = true;
                                                  _showLoginForm = false;
                                                });
                                              },
                                              child: const Text(
                                                'Register!',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: Color.fromARGB(
                                                      255, 252, 254, 255),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        )
                      ],
                    ),
                  ),
                ]),
          ),
        ]),
      ),
    );
  }
}
