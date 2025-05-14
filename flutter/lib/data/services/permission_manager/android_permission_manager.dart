import 'dart:developer' as developer;

import 'package:permission_handler/permission_handler.dart';

import 'permission_manager_interface.dart';

class AndroidPermissionManager implements PermissionManager {
  static final AndroidPermissionManager _instance = AndroidPermissionManager._();
  AndroidPermissionManager._();

  factory AndroidPermissionManager() {
    return _instance;
  }

  @override
  Future<bool> requestBluetoothPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    if (!statuses[Permission.bluetoothScan]!.isGranted ) {
      developer.log('Bluetooth Scan permission not granted');
      return false; // Return early if permissions are not granted
    }

    if (!statuses[Permission.bluetoothConnect]!.isGranted ) {
      developer.log('Bluetooth Connect permission not granted');
      return false; // Return early if permissions are not granted
    }
    
    return true;
  }
}