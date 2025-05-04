import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:neurithm/screens/homepage.dart';
import 'package:neurithm/screens/patient/signalReadingPage.dart';
import 'package:neurithm/widgets/appBar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';
import 'package:neurithm/services/connectToBluetoothService.dart';

class SetUpConnectionPage extends StatefulWidget {
  const SetUpConnectionPage({super.key});

  @override
  State<SetUpConnectionPage> createState() => _SetUpConnectionPageState();
}

class _SetUpConnectionPageState extends State<SetUpConnectionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isScanning = false;
  bool _isScanComplete = false;
  List<BluetoothDevice> bciHeadsets = [];
  final ConnectToBluetoothService _bluetoothService =
      ConnectToBluetoothService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isScanComplete = true;
          });
        }
      });
  }

  void _startScanning() async {
    setState(() {
      _isScanning = true;
      _isScanComplete = false;
      bciHeadsets.clear();
    });

    _controller.repeat();

    final foundDevices = await _bluetoothService.scanForHeadsets();

    setState(() {
      bciHeadsets = foundDevices;
      _isScanning = false;
      _isScanComplete = true;
    });

    _controller.stop();
  }

  void _connectToDevice(BluetoothDevice device) async {
    print("attempting to connect to bluetooth device");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignalReadingpage()),
    );
    try {
      await _bluetoothService.connectToDevice(device);
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: gradientBackground,
            child: Center(
              child: Stack(alignment: Alignment.center, children: [
                wavesBackground(
                    getScreenWidth(context), getScreenHeight(context)),
                    Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing(15, getScreenHeight(context)),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Color.fromARGB(255, 206, 206, 206)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(showRatingPopup: false,),
                      ),
                    );
                  },
                ),
              ),
            ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: spacing(15, getScreenHeight(context))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: getScreenHeight(context) * 0.1),
                        child: const Text(
                          'Connect to a Headset',
                          style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Lato'),
                        ),
                      ),
                      SizedBox(height: spacing(20, getScreenHeight(context))),
                      const Center(
                        child: Text(
                          "Sync your mobile app to your headset to start voicing your thoughts",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 206, 206, 206),
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: spacing(50, getScreenHeight(context))),
                      Container(
                        height: spacing(300, getScreenHeight(context)),
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_isScanning) ...[
                              RippleCircle(
                                  animation: _controller,
                                  radius: 350,
                                  opacity: 0.3),
                              RippleCircle(
                                  animation: _controller,
                                  radius: 300,
                                  opacity: 0.5),
                              RippleCircle(
                                  animation: _controller,
                                  radius: 250,
                                  opacity: 0.7),
                            ],
                            GestureDetector(
                              onTap: _isScanning ? null : _startScanning,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 62, 99, 135),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          const Color.fromARGB(255, 62, 99, 135)
                                              .withOpacity(0.4),
                                      spreadRadius: 4,
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                width: spacing(250, getScreenHeight(context)),
                                height: spacing(250, getScreenHeight(context)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0, right: 30, bottom: 25),
                                    child: Image.asset(
                                      'assets/images/bci.png', // Your waves image path
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _isScanning
                              ? "Scanning..." // Show "Scanning..." during scanning
                              : _isScanComplete
                                  ? (bciHeadsets.isNotEmpty
                                      ? "${bciHeadsets.length} headset(s) found"
                                      : "No headsets found") // Show "Headset was found" after scanning completes
                                  : "",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 254, 255, 255),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_isScanComplete && bciHeadsets.isNotEmpty) ...[
                        Expanded(
                          child: ListView.builder(
                            itemCount: bciHeadsets.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: Text(bciHeadsets[index].name,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  subtitle: Text(
                                      bciHeadsets[index].id.toString(),
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 240, 240, 240),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    onPressed: () =>
                                        _connectToDevice(bciHeadsets[index]),
                                    child: const Text(
                                      "Connect",
                                      style: TextStyle(
                                        color: Color(
                                          0xFF1A2A3A,
                                        ),
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ],
                     
                    ],
                  ),
                ),
              ]),
            )));
  }
}

class RippleCircle extends StatelessWidget {
  final Animation<double> animation;
  final double radius;
  final double opacity;

  const RippleCircle({
    required this.animation,
    required this.radius,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromARGB(255, 62, 99, 135)
                .withOpacity(opacity * (1 - animation.value)),
          ),
        );
      },
    );
  }
}
