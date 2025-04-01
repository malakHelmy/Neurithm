import 'package:flutter/material.dart';
import 'package:neurithm/widgets/appBar.dart';
import 'package:neurithm/widgets/bottomBar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';

class AboutUsPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: sideAppBar(context),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(spacing(5, getScreenHeight(context))),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: BottomBar(context),
          ),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                decoration: gradientBackground,
                child: Stack(
                  children: [
                    waveBackground,
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing(15, getScreenHeight(context)),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            appBar(_scaffoldKey),
                            SizedBox(
                                height: spacing(15, getScreenHeight(context))),
                            const Text(
                              'About us',
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Redefining Means of Communication',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'At Neurithm, we are committed to breaking barriers in communication for individuals with severe speech and movement disabilities. Our system harnesses the power of Brain-Computer Interface (BCI) technology, artificial intelligence, and speech synthesis to transform neural activity into spoken language, empowering users with a new voice.',
                              style: TextStyle(fontSize: 16, height: 1.5),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Our Vision',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'To create a world where communication is limitless, regardless of physical ability. By merging cutting-edge neuroscience with technology, we aim to provide tools that restore independence and enhance human connection.',
                              style: TextStyle(fontSize: 16, height: 1.5),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Our Technology',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '• Non-Invasive BCI: Utilizing EEG headsets, our system captures and interprets brain activity without the need for invasive procedures.\n'
                              '• Deep Learning Models: A multi-layered Long Short-Term Memory (LSTM) network decodes neural signals into coherent speech in real time.\n'
                              '• User-Centered Design: Designed with ease of use in mind, our system is accessible to individuals and caregivers alike.',
                              style: TextStyle(fontSize: 16, height: 1.5),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Why It Matters',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Millions of individuals worldwide live with conditions like ALS, locked-in syndrome, or severe paralysis. Our solution provides them with an avenue for expression, autonomy, and connection—one word at a time.',
                              style: TextStyle(fontSize: 16, height: 1.5),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Meet the Team',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'We are a dedicated group of software engineers, neuroscientists, and innovators passionate about leveraging technology to improve lives. Our multidisciplinary expertise fuels our mission to make cutting-edge solutions accessible to those who need them most.',
                              style: TextStyle(fontSize: 16, height: 1.5),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Acknowledgments',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'We extend our gratitude to our university and partners for their unwavering support and resources, enabling us to bring this project to life.',
                              style: TextStyle(fontSize: 16, height: 1.5),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Get Involved',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'We are continuously looking for collaborators, researchers, and users to shape the future of this technology. Contact us to join the journey!',
                              style: TextStyle(fontSize: 16, height: 1.5),
                            ),
                          ]),
                    ),
                  ],
                ))));
  }
}
