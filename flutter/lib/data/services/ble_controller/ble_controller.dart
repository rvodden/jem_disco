import 'dart:async';

import 'package:jem_disco/data/services/permission_manager/permission_manager_interface.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:developer' as developer;

import '../../../model/device.dart';

Uuid bleUart = Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e");
Uuid bleUartTx = Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e");
Uuid bleUartRx = Uuid.parse("6e400003-b5a3-f393-e0a9-e50e24dcca9e");

class BleController {
  StreamSubscription<ConnectionStateUpdate>? connectionStateUpdateStreamSubscription;
  late QualifiedCharacteristic tx;
  
  final FlutterReactiveBle _flutterReactiveBle;
  final PermissionManager _permissionManager;
  StreamSubscription<DiscoveredDevice>? _discoveredDeviceStreamSubscription;

  final StreamController<bool> _scanningStatus = StreamController.broadcast();
  Stream<bool> get scanningStatus => _scanningStatus.stream;

  BleController({required FlutterReactiveBle flutterReactiveBle, required PermissionManager permissionManager}) :
  _flutterReactiveBle = flutterReactiveBle,
  _permissionManager = permissionManager;

  // List to store discovered devices
  final List<DiscoveredDevice> discoveredDevices = [];

  Future<void> startBluetoothScan(Function(Device) deviceDiscoveredCallback) async {
    _permissionManager.requestBluetoothPermissions();

    if (_flutterReactiveBle.status == BleStatus.ready) {
      developer.log("Start ble discovery");
      _discoveredDeviceStreamSubscription = _flutterReactiveBle.scanForDevices(withServices: [
        bleUart
      ]).listen((discoveredDevice) async {
        if (discoveredDevice.name.isNotEmpty) {
          // Call the callback
          deviceDiscoveredCallback(DeviceFactory.fromDiscoveredDevice(discoveredDevice));
        }
      }, onError: (Object e) => developer.log('Device scan fails with error: $e'));
      _scanningStatus.add(true);
    } else {
      developer.log('Device is not ready for communication. Status is: ${_flutterReactiveBle.status}');
      Future.delayed(const Duration(seconds: 2), () {
        startBluetoothScan(deviceDiscoveredCallback);
      });
    }
  }

  void stopBluetoothScan() {
    if (_discoveredDeviceStreamSubscription != null) {
      _scanningStatus.add(false);
      _discoveredDeviceStreamSubscription!.cancel();
      _discoveredDeviceStreamSubscription = null;
    }
  }

  void connect(Device device) {
    if (_flutterReactiveBle.status == BleStatus.ready) {
        developer.log("Trying to connect to device: ${device.id}");
        _flutterReactiveBle.connectToDevice(id: device.id).listen((state) {
          switch (state.connectionState) {
            case DeviceConnectionState.connected:
              developer.log('Connected to device: ${device.id}');
              tx = QualifiedCharacteristic(
                characteristicId: bleUartTx,
                serviceId: bleUart,
                deviceId: device.id
              );
              break;
            case DeviceConnectionState.connecting:
              developer.log('Connecting to device: ${device.id}');
              break;
            case DeviceConnectionState.disconnected:
              developer.log('Disconnecting from device: ${device.id}');
              break;
            case DeviceConnectionState.disconnecting:
              developer.log('Disconnected from device: ${device.id}');
              break;
          }
        });
    } else {
      developer.log('Device is not ready for communication. Status is: ${_flutterReactiveBle.status}');
    }
  }

  void sendColor(int red, int green, int blue) async {
    await _flutterReactiveBle.writeCharacteristicWithoutResponse(tx, value: [1, red, green, blue, 0]);
  }
  
  // Clean up resources
  void dispose() {
    stopBluetoothScan();
  }
}