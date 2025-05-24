import 'package:flutter/material.dart';

void nullFunction() {}

Widget buildColourButton({required String text, required Color colour, required void Function() sendColor}) {

    return FilledButton(
        onPressed: () { 
          sendColor();
        },
        style: FilledButton.styleFrom(
          backgroundColor: colour
        ),
        child: Text(text)
    );
}

class ColorGrid extends StatelessWidget {
  final void Function(int) _sendCommand;
  const ColorGrid({super.key, required void Function(int) sendCommand}) : _sendCommand = sendCommand;

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
          sendColor: () => _sendCommand(1)
        ),
        buildColourButton(
          text: "Green",
          colour: Colors.green,
          sendColor: () => _sendCommand(2)
        ),
        buildColourButton(
          text: "Blue",
          colour: Colors.blue,
          sendColor: () => _sendCommand(3)
        ),
      ],
    );
  }
}