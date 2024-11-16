import 'package:flutter/material.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize(double size) => size * screenWidth / 400;
    double spacing(double size) => size * screenHeight / 800;

    return Scaffold(
      appBar: AppBar(title: Text("Account Settings")),
      body: Padding(
        padding: EdgeInsets.all(spacing(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Field
            Text("Name", style: TextStyle(fontSize: fontSize(18), color: Colors.black)),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "Enter your name"),
            ),
            SizedBox(height: spacing(20)),

            // Email Field
            Text("Email", style: TextStyle(fontSize: fontSize(18), color: Colors.black)),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(hintText: "Enter your email"),
            ),
            SizedBox(height: spacing(20)),

            // Password Field
            Text("Password", style: TextStyle(fontSize: fontSize(18), color: Colors.black)),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: "Enter your password"),
            ),
            SizedBox(height: spacing(30)),

            // Save Button
            ElevatedButton(
              onPressed: () {
                // Handle saving the changes (e.g., API call, save to local storage)
                // For now, we just print the values.
                print("Name: ${_nameController.text}");
                print("Email: ${_emailController.text}");
                print("Password: ${_passwordController.text}");
              },
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
