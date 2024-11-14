import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/bottombar.dart';
import '../widgets/wavesBackground.dart';
import 'loginPage.dart'; // Import the LoginPage

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize(double size) => size * screenWidth / 400;
    double spacing(double size) => size * screenHeight / 800;

    return Scaffold(
      key: _scaffoldKey,
      drawer: sideAppBar(context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: gradientBackground,
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: screenWidth / screenHeight,
                child: Opacity(
                  opacity: 0.50,
                  child: Image.asset(
                    'assets/images/waves.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drawer appBar
                    Padding(
                      padding: EdgeInsets.only(
                        top: 40,
                      ),
                      child: appBar(_scaffoldKey),
                    ),
                    SizedBox(height: spacing(20)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacing(10)),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.75, // 75% of screen width
                              height: screenHeight * 0.4, // 40% of screen height
                              child: Padding(
                                padding: EdgeInsets.all(spacing(20)),
                                child: const DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        offset: Offset(2, 4),
                                        blurRadius: 6,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/brainsignals.png',
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: spacing(10)),
                            Text(
                              "Welcome, Potential User",
                              style: TextStyle(
                                fontSize: fontSize(28),
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              "Voice Your Mind Effortlessly",
                              style: TextStyle(
                                fontSize: fontSize(22),
                                fontFamily: 'Lato',
                                color: const Color.fromARGB(255, 206, 206, 206),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: spacing(20)),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: spacing(10.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: spacing(13)),
                                ),
                                child: const Text(
                                  "Start Speaking Now",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF1A2A3A),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Help & Guide button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text(
                                  "Help & Guide",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF1A2A3A),
                                  ),
                                ),
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
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(spacing(5)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: bottomappBar(),
        ),
      ),
    );
  }
}
