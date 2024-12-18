import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/bottombar.dart';
import '../screens/history.dart';
import '../screens/devices.dart';
import '../screens/settings.dart';
import '../widgets/wavesBackground.dart';
import 'setUpConnectionPage.dart';

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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(spacing(5)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: bottomappBar(context),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: gradientBackground,
          child: Stack(
            children: [
              wavesBackground(screenWidth, screenHeight),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drawer appBar
                    appBar(_scaffoldKey),

                    SizedBox(height: spacing(15)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacing(10)),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.75,
                              height: screenHeight * 0.4,
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
                            SizedBox(height: spacing(20)),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          setUpConnectionPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 240, 240, 240),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: spacing(13)),
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
                                  backgroundColor:
                                      const Color.fromARGB(255, 240, 240, 240),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
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
                    SizedBox(height: spacing(30)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "History",
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: fontSize(30),
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 206, 206, 206),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: Color.fromARGB(255, 206, 206, 206)),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
