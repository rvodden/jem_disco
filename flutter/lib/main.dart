import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:jem_disco/data/services/ble_controller/ble_controller.dart';
import 'package:jem_disco/model/device.dart';
import 'package:jem_disco/main_page.dart';
import 'package:jem_disco/data/services/permission_manager/permission_manager_interface.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const JemDisco());
}

class JemDisco extends StatelessWidget {
  const JemDisco({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => JemDiscoModel()),
        Provider<PermissionManager>.value(value: PermissionManager()),
        Provider<FlutterReactiveBle>.value(value: FlutterReactiveBle()),
        ProxyProvider2<PermissionManager, FlutterReactiveBle, BleController>(
          update: (context, permissionManager, flutterReactivceBle, bleController) => BleController(
            flutterReactiveBle: flutterReactivceBle,
            permissionManager: permissionManager
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Jem\'s Disco',
        home: const MainPage(),
      )
    );
  }
}
