
import 'package:flutter/material.dart';
import 'package:jem_disco/model/device.dart';
import 'package:jem_disco/ui/main_page/view_model/main_page_view_model.dart';
import 'package:jem_disco/ui/main_page/widgets/colour_grid.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  final MainPageViewModel model;
  const MainPage({super.key, required this.model});

  void _navigateToDeviceListAndShowPopup(BuildContext context) {
    Navigator.pushNamed(
      context,
      "/devices"
    ) as Device;
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


