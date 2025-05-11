import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:equatable/equatable.dart';


class Device extends Equatable {
  final String id;
  final String name;

  const Device({required this.id, required this.name});
  
  @override
  List<Object?> get props => [id, name];
}

/// A factory class for creating [Device] instances.
///
/// This class provides utility methods to convert BLE-specific device objects
/// from the flutter_reactive_ble package into the application's [Device] model.
class DeviceFactory {
  /// Creates a [Device] instance from a [DiscoveredDevice].
  ///
  /// This method extracts the necessary information (id and name) from the
  /// [DiscoveredDevice] object provided by the flutter_reactive_ble package
  /// and creates a simplified [Device] model for use within the application.
  ///
  /// [discoveredDevice] The BLE device discovered during scanning.
  ///
  /// Returns a new [Device] instance with the id and name from the discovered device.
  static Device fromDiscoveredDevice(DiscoveredDevice discoveredDevice) {
    return Device(id: discoveredDevice.id, name: discoveredDevice.name);
  }
}

class JemDiscoModel extends ChangeNotifier {
  
  Device? currentDevice;

  void updateDevice(Device device) {
    currentDevice = device;
    notifyListeners();
  }

  void clearDevice() {
    currentDevice = null;
    notifyListeners();
  }
}