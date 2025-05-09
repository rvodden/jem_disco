import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:developer' as developer;

import 'device.dart';

Uuid bleUart = Uuid.parse("6e400001-b5a3-f393-e0a9-e50e24dcca9e");
Uuid bleUartRx = Uuid.parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e");
Uuid bleUartTx = Uuid.parse("6e400003-b5a3-f393-e0a9-e50e24dcca9e");

class BleController {
  final flutterReactiveBle = FlutterReactiveBle();
  StreamSubscription<DiscoveredDevice>? discoveredDeviceStreamSubscription;
  StreamSubscription<ConnectionStateUpdate>? connectionStateUpdateStreamSubscription;
  late QualifiedCharacteristic tx;
  
  // List to store discovered devices
  final List<DiscoveredDevice> discoveredDevices = [];
  // Stream controller to notify UI of device list changes
  final StreamController<List<DiscoveredDevice>> devicesStreamController = 
      StreamController<List<DiscoveredDevice>>.broadcast();

  Stream<List<DiscoveredDevice>> get deviceStream => devicesStreamController.stream;

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

    // Clear previous devices when starting a new scan
    discoveredDevices.clear();
    devicesStreamController.add(discoveredDevices);

    if (flutterReactiveBle.status == BleStatus.ready) {
      developer.log("Start ble discovery");
      discoveredDeviceStreamSubscription = flutterReactiveBle.scanForDevices(withServices: [
        bleUart
      ]).listen((device) async {
        if (device.name.isNotEmpty) {
          // Call the callback
          discoveredDevice(device);
          
          // Add to our list if not already present
          if (!discoveredDevices.any((d) => d.id == device.id)) {
            discoveredDevices.add(device);
            // Notify listeners about the updated list
            devicesStreamController.add(discoveredDevices);
          }
        }
      }, onError: (Object e) => developer.log('Device scan fails with error: $e'));
    } else {
      developer.log('Device is not ready for communication. Status is: ${flutterReactiveBle.status}');
      Future.delayed(const Duration(seconds: 2), () {
        startBluetoothScan(discoveredDevice);
      });
    }
  }

  void stopBluetoothScan() {
    if (discoveredDeviceStreamSubscription != null) {
      discoveredDeviceStreamSubscription!.cancel();
      discoveredDeviceStreamSubscription = null;
    }
  }

  void connect(Device device) {
    if (flutterReactiveBle.status == BleStatus.ready) {
        developer.log("Trying to connect to device: ${device.id}");
        flutterReactiveBle.connectToDevice(id: device.id).listen((state) {
          if(state.connectionState != DeviceConnectionState.connected) {
            developer.log('Failed to connect to device: ${device.id} with state: ${state.connectionState}');
            return;
          }

          developer.log('Connected to device: ${device.id}');
          tx = QualifiedCharacteristic(
            characteristicId: bleUartTx,
            serviceId: bleUart,
            deviceId: device.id
          );
        });
    } else {
      developer.log('Device is not ready for communication. Status is: ${flutterReactiveBle.status}');
      return;
    }
  }
  
  // Clean up resources
  void dispose() {
    stopBluetoothScan();
    devicesStreamController.close();
  }
}