import 'dart:io' show Platform;
import 'permission_manager_stub.dart'
  // TODO: add more platforms here, e.g., 'permission_manager_ios.dart' for iOS, etc.
  if (Platform.isAndroid) 'android/android_permission_manager.dart';


abstract class PermissionManager {
  Future<void> requestBluetoothPermissions();

  factory PermissionManager() => getPermissionManager();
}