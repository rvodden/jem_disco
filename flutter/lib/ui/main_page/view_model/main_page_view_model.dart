import 'package:flutter/material.dart';

import '../../../data/repository/device_repository/device_repository.dart';

class MainPageViewModel extends ChangeNotifier {
  final DeviceRepository _deviceRepository;

  MainPageViewModel({required DeviceRepository deviceRepository}) : 
    _deviceRepository = deviceRepository;
  
  void sendColor(int red, int green, int blue) {
    _deviceRepository.sendColour(red, green, blue);
  }
}