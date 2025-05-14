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
  final void Function(Color) _sendColor;
  const ColorGrid({super.key, required void Function(Color) sendColor}) : _sendColor = sendColor;

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
          sendColor: () => _sendColor(Color.fromARGB(255, 255, 0, 0))
        ),
        buildColourButton(
          text: "Green",
          colour: Colors.green,
          sendColor: () => _sendColor(Color.fromARGB(255, 0, 255, 0))
        ),
        buildColourButton(
          text: "Blue",
          colour: Colors.blue,
          sendColor: () => _sendColor(Color.fromARGB(255, 0, 0, 255))
        ),
      ],
    );
  }
}