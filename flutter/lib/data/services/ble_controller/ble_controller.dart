import 'dart:async';
import 'dart:typed_data';

import 'package:jem_disco/data/services/permission_manager/permission_manager_interface.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:developer' as developer;

import '../../../model/device.dart';

Uuid bleUart = Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e");
Uuid bleUartTx = Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e");
Uuid bleUartRx = Uuid.parse("6e400003-b5a3-f393-e0a9-e50e24dcca9e");

class BleController {
  StreamSubscription<ConnectionStateUpdate>? connectionStateUpdateStreamSubscription;
  QualifiedCharacteristic? tx;

  final StreamController<Device?> _connectedDevice = StreamController.broadcast();
  Stream<Device?> get connectedDeviceStream => _connectedDevice.stream;

  final FlutterReactiveBle _flutterReactiveBle;
  final PermissionManager _permissionManager;
  StreamSubscription<DiscoveredDevice>? _discoveredDeviceStreamSubscription;

  final StreamController<bool> _scanningStatus = StreamController.broadcast();
  Stream<bool> get scanningStatusStream => _scanningStatus.stream;

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
          developer.log('Discovered device: ${discoveredDevice.name}');
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
    developer.log("Stop Scanning.");
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
              _connectedDevice.add(device);
              break;
            case DeviceConnectionState.connecting:
              developer.log('Connecting to device: ${device.id}');
              break;
            case DeviceConnectionState.disconnected:
              developer.log('Disconnecting from device: ${device.id}');
              tx = null;
              _connectedDevice.add(null);
              break;
            case DeviceConnectionState.disconnecting:
              developer.log('Disconnected from device: ${device.id}');
              tx = null;
              _connectedDevice.add(null);
              break;
          }
        });
    } else {
      developer.log('Device is not ready for communication. Status is: ${_flutterReactiveBle.status}');
    }
  }

  void send(Uint8List message) async {
    // TODO:  handle lack of connection better
    if (tx == null) return;
    await _flutterReactiveBle.writeCharacteristicWithoutResponse(tx!, value: message);
  }
  
  // Clean up resources
  void dispose() {
    stopBluetoothScan();
  }
}