import 'package:flutter/material.dart';
import 'package:jem_disco/ui/main_page/view_model/main_page_view_model.dart';
import 'package:jem_disco/ui/main_page/widgets/color_grid.dart';

class MainPageScreen extends StatelessWidget {
  final MainPageViewModel _model;
  const MainPageScreen({super.key, required MainPageViewModel model}) : _model = model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal, title: Text("Jem's Disco")),
      body: ColorGrid(sendCommand: _model.sendCommand),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, "/devices"),
          tooltip: _model.isConnected ? 'Connected to ${_model.connectedDevice!.name}' : 'Select Device',
          child: _model.isConnected ? Icon(Icons.link_off) : Icon(Icons.link),
      )
    );
  }
}