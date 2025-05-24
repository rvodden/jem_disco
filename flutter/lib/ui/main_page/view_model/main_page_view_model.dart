import 'package:flutter/material.dart';

import '../../../data/repository/device_repository/device_repository.dart';
import '../../../model/device.dart';

class MainPageViewModel extends ChangeNotifier {
  bool isConnected = false;
  Device? connectedDevice;

  MainPageViewModel({required DeviceRepository deviceRepository}) : 
    _deviceRepository = deviceRepository
  { 
    _deviceRepository.connectedDeviceStream.listen((device) {
      isConnected = (device != null);
      connectedDevice = device;
      notifyListeners();
    });
  }

  final DeviceRepository _deviceRepository;
  
  void sendCommand(int command) {
    _deviceRepository.sendCommand(command);
  }
}