import 'package:flutter/material.dart';
import 'package:neurithm/screens/homePage.dart';
import '../widgets/wavesBackground.dart';
import '../widgets/appbar.dart';
import 'settings.dart';

class UserProfileSettingsPage extends StatefulWidget {
  const UserProfileSettingsPage({super.key});

  @override
  State<UserProfileSettingsPage> createState() =>
      _UserProfileSettingsPageState();
}

class _UserProfileSettingsPageState extends State<UserProfileSettingsPage> {
  // Controllers for editable fields
  final TextEditingController firstNameController =
      TextEditingController(text: 'Jana');
   final TextEditingController LastNameController =
      TextEditingController(text: 'Hani');
  final TextEditingController emailController =
      TextEditingController(text: 'janahani.nbis@gmail.com');
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    // nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradientBackground,
        child: Stack(
          children: [
            wavesBackground(getScreenWidth(context), getScreenHeight(context)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing(15, getScreenHeight(context)),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Color.fromARGB(255, 206, 206, 206)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 85),
              child: Column(
                children: [
                  const Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Color.fromARGB(255, 62, 99, 135),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Profile Settings Fields Section
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: ListView(
                        children: [
                          _editableField(Icons.person, 'Edit First Name',
                              controller: firstNameController),
                          _editableField(Icons.person, 'Edit Last Name',
                              controller: LastNameController),
                          _editableField(Icons.email, 'Change Email',
                              controller: emailController),
                          _editableField(Icons.lock, 'Update Password',
                              controller: passwordController,
                              obscureText: true),
                          _editableField(Icons.lock, 'Confirm Password',
                              controller: passwordController,
                              obscureText: true),
                        ],
                      ),
                    ),
                  ),
                  // Save Profile Settings Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Save profile settings functionality
                          // print("Name: ${nameController.text}");
                          // print("Email: ${emailController.text}");
                          // print("Password: ${passwordController.text}");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 240, 240, 240),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: spacing(12, getScreenHeight(context))),
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF1A2A3A),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Editable Field with TextEditingController
  Widget _editableField(IconData icon, String label,
      {required TextEditingController controller, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: Color.fromARGB(255, 206, 206, 206)),
              const SizedBox(width: 25),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: const TextStyle(color: Colors.white54),
                    
                  ),
                ),
              ),
            ],
          ),
        ),
        
      ],
    );
  }

  // Non-editable Field
  Widget _settingsField(IconData icon, String label,
      {Widget? trailing, VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: Color.fromARGB(255, 206, 206, 206)),
                const SizedBox(width: 25),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
        const Divider(
          color: Color.fromARGB(255, 206, 206, 206),
          thickness: 0.75,
        ),
      ],
    );
  }
}
