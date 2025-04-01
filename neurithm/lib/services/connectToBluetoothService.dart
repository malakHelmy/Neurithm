import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectToBluetoothService {
  Future<List<BluetoothDevice>> scanForHeadsets({
    Duration timeout = const Duration(seconds: 5),
    String prefix = "EPOCX",
  }) async {
    List<BluetoothDevice> foundDevices = [];

    await FlutterBluePlus.startScan(timeout: timeout);

    final scanResults = await FlutterBluePlus.scanResults.first;
    for (var result in scanResults) {
      if (result.device.name.isNotEmpty &&
          result.device.name.startsWith(prefix)) {
        if (!foundDevices.any((d) => d.id == result.device.id)) {
          foundDevices.add(result.device);
        }
      }
    }

    await FlutterBluePlus.stopScan();
    return foundDevices;
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
  }
}
