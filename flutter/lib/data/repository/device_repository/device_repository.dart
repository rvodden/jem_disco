import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import '../../services/ble_controller/ble_controller.dart';
import '../../../model/device.dart';

abstract class DeviceRepository {
  void startScan();
  void stopScan();

  Stream<List<Device>> get devicesStream;
  Stream<bool> get scanningStatusStream;
  Stream<Device?> get connectedDeviceStream;

  void connect(Device device);
  void sendCommand(int command);
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
  Stream<bool> get scanningStatusStream => _bleController.scanningStatusStream;

  @override
  void startScan() {
    developer.log('Start scanning...');
    _bleController.startBluetoothScan((device)  {
      if(!_deviceList.contains(device)) {
        _deviceList.add(device);
        _devicesStream.add(_deviceList);
      }
    });
  }

  @override
  void stopScan() {
    developer.log('Stop scanning.');
    _bleController.stopBluetoothScan();
  }
  
  @override
  void sendCommand(int command) {
    _bleController.send(Uint8List.fromList([1, command, 0]));
  }
  
  @override
  void connect(Device device) {
    developer.log('Connecting to ${device.name}...');
    _bleController.connect(device);
  }
  
  @override
  Stream<Device?> get connectedDeviceStream => _bleController.connectedDeviceStream;
  
}