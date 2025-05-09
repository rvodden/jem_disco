import 'package:flutter/material.dart';

class Device {
  final String id;
  final String name;

  Device({required this.id, required this.name});
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