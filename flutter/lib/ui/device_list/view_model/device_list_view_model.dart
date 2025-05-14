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
    _deviceRepository.startScan();
  }

  void stopScan() {
    _deviceRepository.stopScan();
  }

  void connect(Device device) {
    _deviceRepository.connect(device);
  }
}