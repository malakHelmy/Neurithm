import 'package:flutter/material.dart';
import '../screens/loginPage.dart';
import 'inputDecoration.dart';
import '../screens/homePage.dart';

AnimatedOpacity signUpForm(BuildContext context, bool _showLoginForm,
    bool _showSignUpForm, VoidCallback toggleToLoginForm) {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    } else if (value.length < 3) {
      return 'Name should be at least 3 characters';
    } else if (RegExp(r'\d').hasMatch(value)) {
      return 'Name should not contain numbers';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Age should be a number';
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

  return AnimatedOpacity(
    opacity: _showSignUpForm && !_showLoginForm ? 1.0 : 0.0,
    duration: const Duration(milliseconds: 600),
    child: _showSignUpForm
        ? Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  style: const TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
                  decoration: customTextFieldDecoration('First Name'),
                  // validator: _validateName,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _lastNameController,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  decoration: customTextFieldDecoration('Last Name'),
                  // validator: _validateName,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  decoration: customTextFieldDecoration('Email'),
                  // validator: _validateEmail,
                ),
                const SizedBox(height: 20),
                TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    decoration: customTextFieldDecoration('Age')
                    // validator: _validateAge,
                    ),

                const SizedBox(height: 20),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(115, 255, 255, 255)),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 255, 255), width: 2),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ),
                ),                
                const SizedBox(height: 40),
                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
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
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/images/google_logo.png',
                      height: 24,
                      width: 24,
                    ),
                    label: const Text(
                      "Sign Up using Google",
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
                      onPressed: () {
                        toggleToLoginForm();
                      },
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
