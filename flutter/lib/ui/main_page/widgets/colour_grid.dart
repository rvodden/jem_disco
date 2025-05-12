import 'package:flutter/material.dart';

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