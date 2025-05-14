import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:jem_disco/data/repository/device_repository/device_repository.dart';
import 'package:jem_disco/data/services/ble_controller/ble_controller.dart';
import 'package:jem_disco/data/services/permission_manager/android_permission_manager.dart';
import 'package:jem_disco/ui/device_list/view_model/device_list_view_model.dart';
import 'package:jem_disco/ui/main_page/view_model/main_page_view_model.dart';

import 'routes.dart';
import 'ui/device_list/widgets/device_list_screen.dart';
import 'ui/main_page/widgets/main_page_screen.dart';

void main() {
  runApp(JemDisco());
}

class JemDisco extends StatelessWidget {
  const JemDisco({super.key});
  
  @override
  Widget build(BuildContext context) {
    BleController bleController = BleController(
      flutterReactiveBle: FlutterReactiveBle(),
      // TODO: handle other platforms (iOS, Web, etc.)
      permissionManager: AndroidPermissionManager()
    );
    DeviceRepository deviceRepository = BluetoothDeviceRepository(bleController: bleController);
    return MaterialApp(
      title: 'Jem\'s Disco',
      routes: {
        Routes.home: (context) => MainPageScreen(model: MainPageViewModel(deviceRepository: deviceRepository)),
        Routes.devices: (context) => DeviceListScreen(model: DeviceListViewModel(deviceRepository: deviceRepository)),
      },
    );
  }
}
