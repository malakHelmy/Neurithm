import 'package:flutter/material.dart';
import 'package:neurithm/services/authService.dart';
import 'package:neurithm/services/emailService.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/loginForm.dart';
import 'package:neurithm/widgets/customTextField.dart';

import 'package:neurithm/widgets/wavesBackground.dart';

class ForgetPasswordForm extends StatefulWidget {
  const ForgetPasswordForm({super.key});

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final EmailService _emailService = EmailService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize(double size) => size * screenWidth / 400;
    double spacing(double size) => size * screenHeight / 800;
    Future<void> handlePasswordRequest() async {
      final email = _emailController.text.trim();

      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your email')),
        );
        return;
      }

      // Check if the email exists in the system (you can use any method here)
      bool exists = await _authService.doesEmailExist(email);
      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This email is not registered.')),
        );
        return;
      }

      try {
        await resetPassword(context, email); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }

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
          AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: Color.fromARGB(255, 206, 206, 206)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing(25), vertical: screenHeight*0.25),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [const Text(
                    "Neurithm",
                    style: TextStyle(
                      color: Color.fromARGB(255, 206, 206, 206),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Vonique',
                    ),
                  ),SizedBox(height: 10),Text("Forget Password Request", style: TextStyle(fontSize: 25)),
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                          decoration: customTextField('Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ), SizedBox(height: 20)
                        ,
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: handlePasswordRequest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                                    "Submit Request",
                                    style: TextStyle(
                                        fontSize: 20, color: Color(0xFF1A2A3A)),
                                  ),
                          ),
                        ),
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
