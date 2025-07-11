import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:io';
import 'package:neurithm/screens/admin/adminDashboardPage.dart';
import 'package:neurithm/screens/homepage.dart';
import 'package:neurithm/screens/patient/forgetPasswordPage.dart';
import 'package:neurithm/services/authService.dart';
import 'package:neurithm/models/userPreferences.dart';
import 'package:neurithm/services/emailService.dart';
import 'package:neurithm/services/wordBankService.dart';
import 'package:neurithm/widgets/customTextField.dart';

class LoginForm extends StatefulWidget {
  final bool showLoginForm;
  final bool showSignUpForm;
  final VoidCallback toggleToSignUpForm;

  const LoginForm({
    Key? key,
    required this.showLoginForm,
    required this.showSignUpForm,
    required this.toggleToSignUpForm,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final AuthService _authService = AuthService();
  final EmailService _emailService = EmailService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final LocalAuthentication local = LocalAuthentication();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.showLoginForm && (Platform.isIOS || Platform.isAndroid)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _authenticateWithBiometrics();
      });
    }
  }
  WordBankService wordbank = new WordBankService();

  // Method to authenticate using biometrics (fingerprint or Face ID)
  Future<void> _authenticateWithBiometrics() async {
    try {
      bool isAuthenticated = await local.authenticate(
          localizedReason: "Please authenticate with your fingerprint");

      if (isAuthenticated && mounted) {
        Map<String, String?> credentials =
            await UserPreferences.BiometricLogIn();
          print(credentials);
        // Call the sign-in method with the saved credentials
        if (credentials['email'] != null && credentials['password'] != null) {
          var result = await _authService.signInWithEmailPassword(
            credentials['email']!,
            credentials['password']!,
          );
          if (result['success']) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(showRatingPopup: false),
              ),
            );
          }
        }
      }
    } catch (e) {
      print("Biometric authentication failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.showLoginForm ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      child: widget.showLoginForm && !widget.showSignUpForm
          ? Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
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
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPasswordForm()));
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Sign In",
                              style: TextStyle(
                                  fontSize: 20, color: Color(0xFF1A2A3A)),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleGoogleSignIn,
                      icon: Image.asset(
                        'assets/images/google_logo.png',
                        height: 24,
                        width: 24,
                      ),
                      label: const Text(
                        "Continue with Google",
                        style: TextStyle(fontSize: 20, color: Colors.white),
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

                  // ---OR--- divider
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[300],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Login using biometrics
                  TextButton(
                    onPressed: _authenticateWithBiometrics,
                    child: const Text(
                      'Login using biometrics',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Register Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Colors.white70, fontSize: 17),
                      ),
                      TextButton(
                        onPressed: widget.toggleToSignUpForm,
                        child: const Text(
                          'Register!',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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

  // Sign in method for email/password login
  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final result = await _authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        if (result['isAdmin']) {
          // Navigate to admin dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboardPage()),
          );
        } else {
          // Navigate to patient homepage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(showRatingPopup: false)),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result['error'] ?? 'Invalid email or password',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // Sign in using Google
  Future<void> _handleGoogleSignIn() async {
    bool result = await _authService.signInWithGoogle();
    if (result && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(showRatingPopup: false)),
      );
    }
  }
}
