import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
//screens
import '../screens/homePage.dart';
//widgets
import 'appBar.dart';
import 'inputDecoration.dart';

AnimatedOpacity loginForm(
    context, _showLoginForm, _showSignUpForm, VoidCallback toggleToSignUpForm) {

  return AnimatedOpacity(
    opacity: _showLoginForm ? 1.0 : 0.0,
    duration: const Duration(milliseconds: 600),
    child: _showLoginForm && _showSignUpForm == false
        ? Column(
            children: [
              const SizedBox(height: 30),
              TextField(
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  decoration: customTextFieldDecoration('Username')),
              const SizedBox(height: 20),

              // Existing password field
              TextField(
                obscureText: true,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 255, 255, 255),
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forget password?",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Login button
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
                    "Sign In",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF1A2A3A),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
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
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Google login button
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
              SizedBox(
                height: spacing(10, getScreenHeight(context)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Dont have an account?',
                    style: TextStyle(
                        color: Color.fromARGB(115, 255, 255, 255),
                        fontSize: 17),
                  ),
                  TextButton(
                      onPressed: () {
                        toggleToSignUpForm();
                      },
                      child: const Text(
                        'Register!',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color.fromARGB(255, 252, 254, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              )
            ],
          )
        : const SizedBox.shrink(),
  );
}
