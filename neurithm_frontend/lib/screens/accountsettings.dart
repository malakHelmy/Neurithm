import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/bottombar.dart';
import '../widgets/wavesBackground.dart';
import '../screens/accountsettings.dart'; 
import '../screens/voicesettings.dart'; 

class AccountSettingsPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize(double size) => size * screenWidth / 400;
    double spacing(double size) => size * screenHeight / 800;

    return Scaffold(
      key: _scaffoldKey,
      drawer: sideAppBar(context), // Side App Bar
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(spacing(5)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: bottomappBar(context), // Bottom App Bar
        ),
      ),
      body: Container(
        decoration: gradientBackground,
        padding: EdgeInsets.symmetric(horizontal: spacing(15)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("Name", style: TextStyle(fontSize: fontSize(18), color: Colors.white)),
              TextField(
                controller: _nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: spacing(20)),

              Text("Email", style: TextStyle(fontSize: fontSize(18), color: Colors.white)),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: spacing(20)),

              Text("Password", style: TextStyle(fontSize: fontSize(18), color: Colors.white)),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  fillColor: Colors.white.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: spacing(30)),

              // Save Button
              Container(
                width: screenWidth,  
                child: ElevatedButton(
                  onPressed: () {
                    print("Name: ${_nameController.text}");
                    print("Email: ${_emailController.text}");
                    print("Password: ${_passwordController.text}");
                  },
                  child: Text("Save Changes"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: spacing(15)),
                    textStyle: TextStyle(
                      fontSize: fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
