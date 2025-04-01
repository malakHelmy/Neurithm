import 'package:flutter/material.dart';
import 'package:neurithm/screens/patient/accountSettingsPage.dart';
import 'package:neurithm/screens/patient/voiceSettingsPage.dart';
import 'package:neurithm/widgets/appBar.dart';
import 'package:neurithm/widgets/bottomBar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize(double size) => size * screenWidth / 400;
    double spacing(double size) => size * screenHeight / 800;

    return Scaffold(
      key: _scaffoldKey,
      drawer: sideAppBar(context),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(spacing(5)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: BottomBar(context),
        ),
      ),
      body: Container(
        decoration: gradientBackground,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.50,
                child: Image.asset(
                  'assets/images/waves.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drawer appBar
                  appBar(_scaffoldKey),

                  SizedBox(height: spacing(25)),
                  // Account Settings Option
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => accountSettingsPage()),
                      );
                    },
                    child: Container(
                      width: screenWidth,
                      padding: EdgeInsets.symmetric(
                          vertical: spacing(15), horizontal: spacing(20)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_forward_ios,
                              color: Color.fromARGB(255, 11, 3, 26), size: 20),
                          SizedBox(width: spacing(10)),
                          Text(
                            "Account Settings",
                            style: TextStyle(
                              fontSize: fontSize(20),
                              color: const Color.fromARGB(255, 9, 5, 32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: spacing(20)),

                  // Voice Settings Option
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VoiceSettingsPage()),
                      );
                    },
                    child: Container(
                      width: screenWidth,
                      padding: EdgeInsets.symmetric(
                          vertical: spacing(15), horizontal: spacing(20)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_forward_ios,
                              color: Color.fromARGB(255, 11, 3, 26), size: 20),
                          SizedBox(width: spacing(10)),
                          Text(
                            "Voice Settings",
                            style: TextStyle(
                              fontSize: fontSize(20),
                              color: const Color.fromARGB(255, 9, 5, 32),
                            ),
                          ),
                        ],
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
}
