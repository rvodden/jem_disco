import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import 'command.dart';
import 'ble.dart';

void main() {
  runApp(const JemDisco());
}
class JemDisco extends StatelessWidget {
  const JemDisco({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Jem\'s Disco',
      debugShowCheckedModeBanner: false,
      home: MainScreen(title: 'Jem\'s Disco'),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});
  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late BleController bleController;

  @override
  void initState() {
    super.initState();
    bleController = BleController();
    bleController.startBluetoothScan((discoveredDevice) => {
      developer.log('Discovered: ${discoveredDevice.name}'),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal, title: Text(widget.title)),
      body: ColourGrid(),
    );
  }
}

void nullFunction() {}

Widget buildColourButton({required String text, required Color colour}) {
    return FilledButton(
        onPressed: SetColourCommand(color: colour).execute,
        style: FilledButton.styleFrom(
          backgroundColor: colour
        ),
        child: Text(text)
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
