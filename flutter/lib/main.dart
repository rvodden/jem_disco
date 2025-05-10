import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:jem_disco/ble.dart';
import 'package:jem_disco/device.dart';
import 'package:provider/provider.dart';
import 'device_list.dart';
import 'command.dart';

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
        Provider<BleController>.value(
          value: BleController()
        ),
      ],
      child: MaterialApp(
        title: 'Jem\'s Disco',
        home: const MainPage(),
      )
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  Future<void> _navigateToDeviceListAndShowPopup(BuildContext context, JemDiscoModel model) async {
    final device = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeviceList())
    );

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

void nullFunction() {}

Widget buildColourButton({required String text, required Color colour}) {
    return Consumer<JemDiscoModel> (
      builder:(context, value, child) => 
      FilledButton(
        onPressed: () { 
          // TODO: wrap in command pattern
          // SetColourCommand(color: colour).execute()
          Provider.of<BleController>(context, listen: false).sendColor((colour.r * 255).round(), (colour.g * 255).round(), (colour.b * 255).round());
        },
        style: FilledButton.styleFrom(
          backgroundColor: colour
        ),
        child: Text(text)
    )
    );
}

class ColourGrid extends StatelessWidget {
  const ColourGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: true,
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        buildColourButton(
          text: "Red",
          colour: Colors.red,
        ),
        buildColourButton(
          text: "Green",
          colour: Colors.green,
        ),
        buildColourButton(
          text: "Blue",
          colour: Colors.blue,
        ),
      ],
    );
  }
}
