import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:jem_disco/data/services/ble_controller/ble_controller.dart';

import '../../../model/device.dart';

abstract class DeviceRepository {
  void startScan();
  void stopScan();

  Stream<List<Device>> get devicesStream;
  Stream<bool> get scanningStatusStream;
  Stream<Device?> get connectedDeviceStream;

  void connect(Device device);
  void sendColor(Color color);
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
  void sendColor(Color color) {
    int scale(double v, [int scale = 255]) => (v * scale).round();
    
    _bleController.send(Uint8List.fromList([1, scale(color.r), scale(color.g), scale(color.b), 0]));
  }
  
  @override
  void connect(Device device) {
    _bleController.connect(device);
  }
  
  @override
  Stream<Device?> get connectedDeviceStream => _bleController.connectedDeviceStream;
  
}