import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'App.dart';

void main(List<String> args) {
  String filepath;
  if (args != null && args.isNotEmpty) {
    filepath = args[0];
  }
  runApp(App(filepath));

  doWhenWindowReady(() {
    appWindow.minSize = Size(400, 300);
    appWindow.size = Size(800, 600);
    appWindow.alignment = Alignment.center;
    // appWindow.title = "Custom window with Flutter";
    appWindow.show();
  });
}
