import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:jem_disco/data/services/ble_controller/ble_controller.dart';

import '../../../model/device.dart';

abstract class DeviceRepository {
  void startScan();
  void stopScan();

  Stream<List<Device>> get devicesStream;
  Stream<bool> get scanningStatusStream;

  sendColour(int red, int green, int blue);
}

class BluetoothDeviceRepository implements DeviceRepository {
  BluetoothDeviceRepository({required BleController bleController}) :
    _bleController = bleController;

  final BleController _bleController;
  final List<Device> _deviceList = [];
  final StreamController<List<Device>> _devicesStream = StreamController<List<Device>>.broadcast();
  
  @override
  Stream<List<Device>> get devicesStream => _devicesStream.stream;
  
  @override
  Stream<bool> get scanningStatusStream => _bleController.scanningStatus;

  @override
  void startScan() {
    _bleController.startBluetoothScan((device)  {
      _deviceList.add(device);
    });
  }

  @override
  void stopScan() {
    _bleController.stopBluetoothScan();
  }
  
  @override
  sendColour(int red, int green, int blue) {
    _bleController.send([1, red, green, blue, 0] as Uint8List);
  }
  
}