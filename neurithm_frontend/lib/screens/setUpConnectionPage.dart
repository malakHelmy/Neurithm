import 'package:flutter/material.dart';
import 'package:neurithm_frontend/screens/homePage.dart';
import '../widgets/wavesBackground.dart';
import '../widgets/appBar.dart';

class setUpConnectionPage extends StatefulWidget {
  const setUpConnectionPage({super.key});

  @override
  State<setUpConnectionPage> createState() => _setUpConnectionPageState();
}

class _setUpConnectionPageState extends State<setUpConnectionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shadowBlurAnimation;
  late Animation<double> _shadowSpreadAnimation;

  @override
  void initState() {
    super.initState(); // Ensure this line is included

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _shadowBlurAnimation =
        Tween<double>(begin: 6.0, end: 10.0).animate(_controller);
    _shadowSpreadAnimation =
        Tween<double>(begin: 10.0, end: 25.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
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
                  horizontal: spacing(25, getScreenHeight(context))),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: getScreenHeight(context) * 0.1),
                      child: const Text(
                        'Connect to a Headset',
                        style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Lato'),
                      ),
                    ),
                    SizedBox(
                      height: spacing(50, getScreenHeight(context)),
                    ),
                    SizedBox(
                      width: getScreenWidth(context) * 0.75,
                      height: getScreenHeight(context) * 0.4,
                      child: Padding(
                        padding: EdgeInsets.all(
                            spacing(20, getScreenHeight(context))),
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x3F000000),
                                    offset: const Offset(2, 4),
                                    blurRadius: _shadowBlurAnimation.value,
                                    spreadRadius: _shadowSpreadAnimation.value,
                                  ),
                                ],
                              ),
                              child: child,
                            );
                          },
                          child: const Center(
                            child: Text(
                              'Scan',
                              style: TextStyle(color: Colors.grey, fontSize: 50),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: spacing(200, getScreenHeight(context)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 165,
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
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 240, 240),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      spacing(12, getScreenHeight(context))),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Color(0xFF1A2A3A),
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Go Back",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF1A2A3A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 165,
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
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 240, 240),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      spacing(12, getScreenHeight(context))),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Next",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF1A2A3A),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF1A2A3A),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
