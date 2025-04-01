import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:neurithm/screens/patient/signalReadingPage.dart';
import 'package:neurithm/widgets/appBar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';

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
    final flutterBlue = FlutterBluePlus();

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.name.isNotEmpty &&
            result.device.name.startsWith("EPOCX")) {
          if (!bciHeadsets.any((d) => d.id == result.device.id)) {
            setState(() {
              bciHeadsets.add(result.device);
            });
          }
        }
      }
    });

    await Future.delayed(const Duration(seconds: 5));
    await FlutterBluePlus.stopScan();

    _controller.stop();
    setState(() {
      _isScanning = false;
      _isScanComplete = true;
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    await device.connect();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignalReadingpage(),
      ),
    );
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              wavesBackground(
                  getScreenWidth(context), getScreenHeight(context)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: spacing(15, getScreenHeight(context))),
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
                    GestureDetector(
                      onTap: _isScanning ? null : _startScanning,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 62, 99, 135),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 62, 99, 135)
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
                            child: Image.asset('assets/images/bci.png'),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        _isScanning
                            ? "Scanning..."
                            : _isScanComplete
                                ? (bciHeadsets.isNotEmpty
                                    ? "${bciHeadsets.length} headset(s) found"
                                    : "No headsets found")
                                : "",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 254, 255, 255),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (_isScanComplete && bciHeadsets.isNotEmpty) ...[
                      Expanded(
                        child: ListView.builder(
                          itemCount: bciHeadsets.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(bciHeadsets[index].name,
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(bciHeadsets[index].id.toString(),
                                  style: const TextStyle(color: Colors.grey)),
                              trailing: ElevatedButton(
                                onPressed: () =>
                                    _connectToDevice(bciHeadsets[index]),
                                child: const Text("Connect"),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    SizedBox(height: spacing(80, getScreenHeight(context))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 165,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 240, 240),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      spacing(12, getScreenHeight(context))),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_back_ios,
                                    color: Color(0xFF1A2A3A), size: 20),
                                SizedBox(width: 5),
                                Text("Go Back")
                              ],
                            ),
                          ),
                        ),
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
