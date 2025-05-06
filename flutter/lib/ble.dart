import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:developer' as developer;

Uuid bleUart = Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e");
Uuid bleUartRx = Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e");
Uuid bleUartTx = Uuid.parse("6e400003-b5a3-f393-e0a9-e50e24dcca9e");

class BleController {
  final flutterReactiveBle = FlutterReactiveBle();
  StreamSubscription<DiscoveredDevice>? streamSubscription;

  void startBluetoothScan(Function(DiscoveredDevice) discoveredDevice) async {
    if (flutterReactiveBle.status == BleStatus.ready) {
      developer.log("Start ble discovery");
      streamSubscription = flutterReactiveBle.scanForDevices(withServices: [
        bleUart
      ]).listen((device) async {
        if (device.name.isNotEmpty) discoveredDevice(device);
      }, onError: (Object e) => developer.log('Device scan fails with error: $e'));
    } else {
      developer.log("Device is not ready for communication");
      Future.delayed(const Duration(seconds: 2), () {
        startBluetoothScan(discoveredDevice);
      });
    }
  }
}