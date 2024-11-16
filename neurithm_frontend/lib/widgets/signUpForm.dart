import 'package:flutter/material.dart';
import '../screens/homePage.dart';

AnimatedOpacity signUpForm(BuildContext context, bool _showLoginForm, bool _showSignUpForm) {
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
    opacity: _showSignUpForm && _showLoginForm == false ? 1.0 : 0.0,
    duration: const Duration(milliseconds: 600),
    child: _showSignUpForm
        ? Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    style:
                        const TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
                    decoration: InputDecoration(
                      hintText: "First Name",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    // validator: _validateName,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _lastNameController,
                    style:
                        const TextStyle(fontSize: 20, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Last Name",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    // validator: _validateName,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    style:
                        const TextStyle(fontSize: 20, color:  Colors.white),
                    decoration: InputDecoration(
                      hintText: "Email",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    // validator: _validateEmail,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    style:
                        const TextStyle(fontSize: 20, color:  Colors.white),
                    decoration: InputDecoration(
                      hintText: "Age",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      )
                    ),
                    // validator: _validateAge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style:
                        const TextStyle(fontSize: 20, color:  Colors.white),
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    // validator: _validatePassword,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    style:
                        const TextStyle(fontSize: 20, color:  Colors.white),
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    // validator: _validateConfirmPassword,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12,)
                      ),
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFF1A2A3A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink(),
  );
}
