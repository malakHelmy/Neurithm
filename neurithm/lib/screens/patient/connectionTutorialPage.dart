import 'package:flutter/material.dart';
import 'package:neurithm/screens/patient/setUpConnectionPage.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/bottomBar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';

class TutorialPage extends StatefulWidget {
  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  int currentStep = 0;

  final List<Map<String, String>> tutorialSteps = [
    {
      'image': 'assets/images/headset_package.png',
      'text': 'Get your headset (Emotiv Epoc X) out of its package.'
    },
    {
      'image': 'assets/images/saline_solution.png',
      'text':
          'Hydrate the sensor felts using saline solution. Do not use contact lens cleaning or sterilizing solutions.'
    },
    {
      'image': 'assets/images/soak_sensors.png',
      'text':
          'Place the sensor felts in a glass, add saline solution, and soak. Squeeze out excess fluid before inserting them into the sensors.'
    },
    {
      'image': 'assets/images/rehydrate_sensors.png',
      'text':
          'To rehydrate sensors while using the headset, add saline solution through the top opening of each sensor.'
    },
    {
      'image': 'assets/images/headset_power_on.png',
      'text':
          'Insert the sensor felts into each sensor opening and press the power button to turn on the headset. A white LED will illuminate, and the headset will beep.To optimize the use of your headset, we recommend that you fully charge it before making recordings.'
    },
    {
      'image': '',
      'text':
          'Turn on Bluetooth on your phone and navigate to the "Connect to Headset" page.'
    },
    {
      'image': '',
      'text':
          'Click the big circular button to scan for devices and select the headset when it appears.'
    },
    {
      'image': '',
      'text': 'Once connected, you can start the thought translation process!'
    },
  ];

  void nextStep() {
    if (currentStep < tutorialSteps.length - 1) {
      _pageController.animateToPage(
        currentStep + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        currentStep++;
      });
    }
  }

  void prevStep() {
    if (currentStep > 0) {
      _pageController.animateToPage(
        currentStep - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      drawer: sideAppBar(context),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(spacing(5, getScreenHeight(context))),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: BottomBar(context, -1),
        ),
      ),
      body: Stack(
        children: [
          waveBackground,
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: spacing(15, getScreenHeight(context))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                appBar(_scaffoldKey),
                SizedBox(height: spacing(20, getScreenHeight(context))),
                const Center(
                  child: Text(
                    'Connection Tutorial',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentStep = index;
                        });
                      },
                      itemCount: tutorialSteps.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (tutorialSteps[index]['image']!.isNotEmpty)
                              Image.asset(
                                tutorialSteps[index]['image']!,
                                height: 250,
                              ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, left: 10, right: 10),
                              child: Text(
                                tutorialSteps[index]['text']!,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (index == tutorialSteps.length - 1) 
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0,  left: 15, right: 15),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SetUpConnectionPage(),
                                    ),
                                  );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical:
                                            spacing(12, getScreenHeight(context)),
                                        horizontal: 30,
                                      ),
                                    ),
                                    child: const Text(
                                      "Start Speaking Now",
                                      style: TextStyle(
                                          fontSize: 18, color: Color(0xFF1A2A3A)),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 165,
                      child: ElevatedButton(
                        onPressed: currentStep == 0 ? null : prevStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 240, 240, 240),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.symmetric(
                              vertical: spacing(12, getScreenHeight(context))),
                        ),
                        child: 
                            Text("Go Back",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(
                                      0xFF1A2A3A,
                                    )))
                         
                      ),
                    ),
                    if(currentStep < tutorialSteps.length - 1)
                    SizedBox(
                      width: 165,
                      child: ElevatedButton(
                        onPressed: currentStep == tutorialSteps.length - 1
                            ? null
                            : nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 240, 240, 240),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.symmetric(
                              vertical: spacing(12, getScreenHeight(context))),
                        ),
                        child: const Text("Next",
                            style: TextStyle(
                                fontSize: 18,
                                color: Color(
                                  0xFF1A2A3A,
                                ))),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
