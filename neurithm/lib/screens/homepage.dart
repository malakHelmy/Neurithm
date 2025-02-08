import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:neurithm/models/patient.dart';
import 'package:neurithm/screens/setUpConnectionPage.dart';
import 'package:neurithm/services/auth.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/bottombar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class HomePage extends StatefulWidget {
  bool showRatingPopup;

  // Ensure the constructor accepts 'showRatingPopup' parameter
  HomePage({Key? key, required this.showRatingPopup}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthMethods _authMethods = AuthMethods();
  Patient? _currentUser;
  bool _isLoading = true;
  double _userRating = 0;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    Patient? user = await _authMethods.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });

      // If the flag is set and random logic triggers the rating pop-up
      if (widget.showRatingPopup) {
        _showRatingPopup(); // Show rating pop-up if flag is true
      }

      // Track app open count using SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int openCount = prefs.getInt('open_count') ?? 0;
      openCount++;
      await prefs.setInt('open_count', openCount);

      // Show rating pop-up every 3rd app open
      if (openCount % 10 == 0) {
        _showRatingPopup();

        // Reset the open count to 0 after 3rd time
        await prefs.setInt('open_count', 0);
      }
    }
  }

  // Show the rating pop-up with star rating
  void _showRatingPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A2A3A), // Dark-themed background
          title: Text(
            'Rate Our App',
            style: TextStyle(
              fontSize: 24, // Larger font size for the title
              fontWeight: FontWeight.bold,
              color: Colors.white, // Title color (light)
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Please rate our app by selecting stars!",
                style: TextStyle(
                  fontSize: 18, // Larger font size for the content
                  color: Colors.white, // Content color (light)
                ),
              ),
              SizedBox(height: 20),
              RatingBar.builder(
                initialRating: _userRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 50, // Bigger stars
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star_border, // Use border for unselected stars
                  color: Colors.amber, // Border color for unselected stars
                  size: 50, // Ensure the stars are large enough
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _userRating = rating;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: Colors.blue, // Button color
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 20, // Larger button text size
                  color: Colors.white, // Button text color (light)
                ),
              ),
              onPressed: () async {
                // Save the rating to the database or model
                if (_currentUser != null && _userRating > 0) {
                  await _saveRatingToDatabase();
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: Colors.grey, // Button color
              ),
              child: Text(
                'Later',
                style: TextStyle(
                  fontSize: 20, // Larger button text size
                  color: Colors.white, // Button text color (light)
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Save the rating to Firestore in the rating collection
  Future<void> _saveRatingToDatabase() async {
    if (_currentUser != null) {
      // Generate a custom ratingId (like feedbackId)
      String ratingId = FirebaseFirestore.instance.collection('ratings').doc().id;

      try {
        await FirebaseFirestore.instance.collection('ratings').add({
          'patientId': _currentUser!.uid, // Store the patient's ID
          'rating': _userRating.toInt(), // Rating as a number (1-5)
        });

        print("Rating saved with ratingId: $ratingId");
      } catch (e) {
        print("Error saving rating: $e");
      }
    }
  }

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
                padding: EdgeInsets.symmetric(horizontal: spacing(15)),
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

                            // Show loading or user name
                            _isLoading
                                ? CircularProgressIndicator()
                                : Text(
                                    "Welcome, ${_currentUser?.firstName ?? ''} ${_currentUser?.lastName ?? ''}",
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
