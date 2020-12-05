import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'ImgViewer.dart';

void main(List<String> args) {
  String filepath;
  if (args != null && args.isNotEmpty) {
    filepath = args[0];
  }
  runApp(MyApp(filepath));

  doWhenWindowReady(() {
    // var win = appWindow;
    appWindow.minSize = Size(400, 300);
    appWindow.alignment = Alignment.center;
    // win.title = "Custom window with Flutter";
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp(this.filepath);
  final String filepath;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImgViewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ImgViewer(filepath: filepath),
    );
  }
}
