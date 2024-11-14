import 'package:flutter/material.dart';
import '../screens/homePage.dart';

AnimatedOpacity loginForm(context, _showLoginForm, _showSignUpForm) {
  return AnimatedOpacity(
    opacity: _showLoginForm ? 1.0 : 0.0,
    duration: const Duration(milliseconds: 600),
    child: _showLoginForm && _showSignUpForm == false
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                TextField(
                  style:
                      const TextStyle(fontSize: 20, color: Color(0xFF1A2A3A)),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                    hintText: "Username",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  style:
                      const TextStyle(fontSize: 20, color: Color(0xFF1A2A3A)),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                    hintText: "Password",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
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
                            builder: (context) => HomePage(),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A2A3A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
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
                const SizedBox(height: 10),TextButton(onPressed: (){}, child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 252, 254, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                const SizedBox(
                  height: 190,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Dont have an account?', style: TextStyle(fontSize: 17),),
                    TextButton(
                        onPressed: () {},
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
            ),
          )
        : const SizedBox.shrink(),
  );
}
