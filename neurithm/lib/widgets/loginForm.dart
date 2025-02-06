import 'package:flutter/material.dart';
import '../screens/homePage.dart';
import 'inputDecoration.dart';
import '../services/auth.dart';

AnimatedOpacity loginForm(
    BuildContext context,
    bool _showLoginForm,
    bool _showSignUpForm,
    VoidCallback toggleToSignUpForm) {
  final AuthMethods _authMethods = AuthMethods();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  return AnimatedOpacity(
    opacity: _showLoginForm ? 1.0 : 0.0,
    duration: const Duration(milliseconds: 600),
    child: _showLoginForm && !_showSignUpForm
        ? Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  decoration: customTextFieldDecoration('Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
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
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle:
                        const TextStyle(color: Color.fromARGB(115, 255, 255, 255)),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    enabledBorder: const UnderlineInputBorder(
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
                    onPressed: () {}, // Implement password reset
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _isLoading = true;

                        bool result = await _authMethods.signInWithEmailPassword(
                          _emailController.text,
                          _passwordController.text,
                        );

                        _isLoading = false;

                        if (result) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Wrong email or password.', style:TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                            "Sign In",
                            style: TextStyle(fontSize: 20, color: Color(0xFF1A2A3A)),
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

                // Google Sign-In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      bool result = await _authMethods.signInWithGoogle();
                      if (result) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }
                    },
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

                // Register Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Colors.white70, fontSize: 17),
                    ),
                    TextButton(
                      onPressed: toggleToSignUpForm,
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
