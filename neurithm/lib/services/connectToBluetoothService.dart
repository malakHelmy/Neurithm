import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectToBluetoothService {
  Future<List<BluetoothDevice>> scanForHeadsets({
    Duration timeout = const Duration(seconds: 5),
    String prefix = "EPOCX",
  }) async {
    print("inside bluetooth connection");
    List<BluetoothDevice> foundDevices = [];
    bool isScanning = true;

    // Start scanning
    FlutterBluePlus.startScan(timeout: timeout);

    // Listen for scan results
    final scanSubscription = FlutterBluePlus.scanResults.listen((scanResults) {
      for (var result in scanResults) {
        if (result.device.name.isNotEmpty) {
          // Add unique devices only
          if (!foundDevices.any((d) => d.id == result.device.id)) {
            print("Device: "+ result.device.toString());
            foundDevices.add(result.device);
          }
        }
      }
    });

    // Wait for the scan to finish (using timeout duration)
    await Future.delayed(timeout);

    // Stop scanning after the timeout
    await FlutterBluePlus.stopScan();
    scanSubscription.cancel();
     final fakeDevice = BluetoothDevice(
      remoteId: DeviceIdentifier("EPOC X")
    );
    foundDevices.add(fakeDevice);
    return foundDevices;
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
  }
}
