import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/bottombar.dart';
import '../widgets/wavesBackground.dart';
import 'homePage.dart'; // Assuming you are importing the HomePage

class FeedbackPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _feedbackController = TextEditingController();

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
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.075),
                      child: appBar(_scaffoldKey),
                    ),
                    SizedBox(height: spacing(15)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacing(10)),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Feedback Icon
                            SizedBox(
                              width: screenWidth * 0.55,
                              height: screenHeight * 0.3,
                              child: Padding(
                                padding: EdgeInsets.all(spacing(20)),
                                child: const DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        offset: Offset(2, 4),
                                        blurRadius: 6,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.feedback,
                                      size: 80, 
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: spacing(30)),
                            Text(
                              "Your Feedback Matters",
                              style: TextStyle(
                                fontSize: fontSize(23),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Help us improve your experience",
                              style: TextStyle(
                                fontSize: fontSize(17),
                                fontFamily: 'Lato',
                                color: const Color.fromARGB(255, 206, 206, 206),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: spacing(100)),
                            // Feedback Type Section
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: spacing(20)),
                              child: DropdownButtonFormField<String>(
                                hint: Text(
                                  'Select Feedback Type',
                                  style: TextStyle(
                                    fontSize: fontSize(15),
                                    color: Colors.grey,
                                  ),
                                ),
                                items: [
                                  DropdownMenuItem(value: 'Compliment', child: Text('Compliment')),
                                  DropdownMenuItem(value: 'Complaint', child: Text('Complaint')),
                                  DropdownMenuItem(value: 'Suggestion', child: Text('Suggestion')),
                                ],
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: spacing(20)),
                            // Feedback Text Field
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: spacing(20)),
                              child: TextField(
                                controller: _feedbackController,
                                maxLines: 5,
                                style: TextStyle(fontSize: fontSize(15), color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: 'Enter your feedback...',
                                  hintStyle: TextStyle(fontSize: fontSize(18), color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: spacing(20)),
                            // Star Rating Section
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: spacing(20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return IconButton(
                                    icon: Icon(
                                      index < 3 ? Icons.star : Icons.star_border,
                                      color: Colors.yellow[700],
                                    ),
                                    onPressed: () {},
                                  );
                                }),
                              ),
                            ),
                            SizedBox(height: spacing(20)),
                            // Submit Feedback Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle feedback submission
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(), // Redirect to HomePage
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
                                  "Submit Feedback",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF1A2A3A),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: spacing(100)),

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
    );
  }
}
