import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:jem_disco/data/repository/device_repository/device_repository.dart';
import 'package:jem_disco/data/services/ble_controller/ble_controller.dart';
import 'package:jem_disco/data/services/permission_manager/android_permission_manager.dart';
import 'package:jem_disco/ui/device_list/view_model/device_list_view_model.dart';
import 'package:jem_disco/ui/main_page/view_model/main_page_view_model.dart';
import 'package:provider/provider.dart';

import 'data/services/permission_manager/permission_manager_interface.dart';
import 'routes.dart';
import 'ui/device_list/widgets/device_list_screen.dart';
import 'ui/main_page/widgets/main_page_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: FlutterReactiveBle()),
        Provider<PermissionManager>.value(value: AndroidPermissionManager()),
        Provider<BleController>(create: (context) => BleController(
          flutterReactiveBle: context.read<FlutterReactiveBle>(),
          permissionManager: context.read<PermissionManager>())
        ),
        Provider<DeviceRepository>(create: (context) => BluetoothDeviceRepository(bleController: context.read<BleController>()),),
        ChangeNotifierProvider(create:(context) => MainPageViewModel(
          deviceRepository: context.read<DeviceRepository>())
        ),
        ChangeNotifierProvider(create:(context) => DeviceListViewModel(
          deviceRepository: context.read<DeviceRepository>()),
        ),
      ],
      child: JemDisco()
    )
  ); // runApp
}

class JemDisco extends StatelessWidget {
  const JemDisco({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jem\'s Disco',
      routes: {
        Routes.home: (context) => MainPageScreen(model: context.read<MainPageViewModel>()),
        Routes.devices: (context) => DeviceListScreen(model: context.read<DeviceListViewModel>()),
      },
      initialRoute: Routes.home,
    );
  }
}
