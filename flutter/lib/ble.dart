import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:developer' as developer;

Uuid bleUart = Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e");
Uuid bleUartRx = Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e");
Uuid bleUartTx = Uuid.parse("6e400003-b5a3-f393-e0a9-e50e24dcca9e");

class BleController {
  final flutterReactiveBle = FlutterReactiveBle();
  StreamSubscription<DiscoveredDevice>? streamSubscription;

  Future<void> _requestBluetoothPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    if (!statuses[Permission.bluetoothScan]!.isGranted ) {
      developer.log('Bluetooth Scan permission not granted');
      return; // Return early if permissions are not granted
    }

    if (!statuses[Permission.bluetoothConnect]!.isGranted ) {
      developer.log('Bluetooth Connect permission not granted');
      return; // Return early if permissions are not granted
    }
  }

  void startBluetoothScan(Function(DiscoveredDevice) discoveredDevice) async {
    _requestBluetoothPermissions();

    if (flutterReactiveBle.status == BleStatus.ready) {
      developer.log("Start ble discovery");
      streamSubscription = flutterReactiveBle.scanForDevices(withServices: [
        bleUart
      ]).listen((device) async {
        if (device.name.isNotEmpty) discoveredDevice(device);
      }, onError: (Object e) => developer.log('Device scan fails with error: $e'));
    } else {
      developer.log('Device is not ready for communication. Status is: ${flutterReactiveBle.status}');
      Future.delayed(const Duration(seconds: 2), () {
        startBluetoothScan(discoveredDevice);
      });
    }
  }

  void stopBluetoothScan() {
    if (streamSubscription != null) {
      streamSubscription!.cancel();
      streamSubscription = null;
    }
  }
}