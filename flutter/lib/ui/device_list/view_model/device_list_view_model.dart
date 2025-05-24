import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import '../../../data/repository/device_repository/device_repository.dart';
import '../../../model/device.dart';

class DeviceListViewModel extends ChangeNotifier {
  bool isScanning = false;
  List<Device> devices = [];
  String title = 'Discovered Devices';

  DeviceListViewModel({required DeviceRepository deviceRepository}) :
    _deviceRepository = deviceRepository 
  {
    _deviceRepository.scanningStatusStream.listen((bool isScanning) {
      developer.log("Scanning status changed: $isScanning");
      this.isScanning = isScanning;
      notifyListeners();
    });

    _deviceRepository.devicesStream.listen((List<Device> devices) {
      this.devices = devices;
      notifyListeners();
    });
  }
  
  final DeviceRepository _deviceRepository;

  void startScan() {
    developer.log('Starting scanning');
    _deviceRepository.startScan();
  }

  void stopScan() {
    developer.log('Stopping scanning');
    _deviceRepository.stopScan();
  }

  void connect(Device device) {
    developer.log('Connecting to ${device.name} @ ${device.id} ');
    _deviceRepository.connect(device);
  }
}