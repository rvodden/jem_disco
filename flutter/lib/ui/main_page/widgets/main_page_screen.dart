
import 'package:flutter/material.dart';
import 'package:jem_disco/data/services/ble_controller/ble_controller.dart';
import 'package:jem_disco/model/device.dart';
import 'package:jem_disco/ui/main_page/widgets/colour_grid.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  Future<void> _navigateToDeviceListAndShowPopup(BuildContext context, JemDiscoModel model) async {
    final Device device = await Navigator.pushNamed(
      context,
      "/devices"
    ) as Device;

    if (!context.mounted) return;

    Provider.of<BleController>(context, listen: false).connect(device);
    model.updateDevice(device);

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Connected to ${device.name} @ ${device.id}...')
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal, title: Text("Jem's Disco")),
      body: ColourGrid(),
      floatingActionButton: Consumer<JemDiscoModel> (
        builder: (context, model, child) => FloatingActionButton(
          onPressed: () { _navigateToDeviceListAndShowPopup(context, model); },
          tooltip: 'Select Device',
          child: model.currentDevice == null ? Icon(Icons.link_off) : Icon(Icons.link),
      )
      )
    );
  }
} 


