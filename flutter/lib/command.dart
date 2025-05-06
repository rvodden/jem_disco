import 'package:flutter/material.dart';
import 'dart:developer' as developer;

abstract class Command<T> {
  T execute();
}

class SetColourCommand extends Command<void> {
  SetColourCommand({required this.color});

  final Color color;

  @override
  void execute() {
    developer.log('Set color to : $color');
  }
}