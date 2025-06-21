import 'package:flutter/material.dart';
import 'dart:io';

import 'package:neurithm/screens/homepage.dart';
import 'package:neurithm/screens/patient/enableBiometricPage.dart';
import 'package:neurithm/screens/patient/setLanguage.dart';
import 'package:neurithm/services/authService.dart';
import 'package:neurithm/widgets/customTextField.dart';

class SignUpForm extends StatefulWidget {
  final bool showLoginForm;
  final bool showSignUpForm;
  final VoidCallback toggleToLoginForm;

  const SignUpForm({
    Key? key,
    required this.showLoginForm,
    required this.showSignUpForm,
    required this.toggleToLoginForm,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a name';
    } else if (value.length < 3) {
      return 'Name should be at least 3 characters';
    }
    if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value.trim())) {
      return 'Name must contain only letters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 6) {
      return 'Password should be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView (
      child: widget.showSignUpForm && !widget.showLoginForm
          ? Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    decoration: customTextField('First Name'),
                    validator: _validateName,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _lastNameController,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    decoration: customTextField('Last Name'),
                    validator: _validateName,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    decoration: customTextField('Email'),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 20),
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                    decoration: const InputDecoration(
                      labelText: "Password",
                      labelStyle:
                          TextStyle(color: Color.fromARGB(115, 255, 255, 255)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 20),
                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle:
                          TextStyle(color: Color.fromARGB(115, 255, 255, 255)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    validator: _validateConfirmPassword,
                  ),
                  const SizedBox(height: 40),
                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          bool result =
                              await _authService.signUpWithEmailPassword(
                            _firstNameController.text.trim(),
                            _lastNameController.text.trim(),
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
      
                          if (result) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EnablebiometricPage(_emailController.text, _passwordController.text),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'This is a repeated email, try another email',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255))),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF1A2A3A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Sign in with Google Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        bool result = await _authService.signInWithGoogle();
                        if (result) {
                          widget.toggleToLoginForm;
                        }
                      },
                      icon: Image.asset(
                        'assets/images/google_logo.png',
                        height: 24,
                        width: 24,
                      ),
                      label: const Text(
                        "Continue with Google",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? ",
                          style: TextStyle(
                              color: Color.fromARGB(115, 255, 255, 255),
                              fontSize: 17)),
                      TextButton(
                        onPressed: widget.toggleToLoginForm,
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
