import 'package:flutter/material.dart';
import 'ImgViewer.dart';
import 'Utils.dart';
import 'ThemeData.dart';

class App extends StatefulWidget {
  App(this.filepath);
  final String filepath;

  @override
  _AppState createState() => _AppState();

  static _AppState of(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>();
}

class _AppState extends State<App> {
  Map<LogicalKeySet, Intent> _shortcuts;

  set shortcuts(Map<LogicalKeySet, Intent> value) =>
      setState(() => _shortcuts = value);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImgViewer',
      actions: <Type, Action<Intent>>{
        CallbackIntent: CallbackAction<CallbackIntent>(
          onInvoke: (CallbackIntent intent) {
            return intent.callback();
          },
        ),
      },
      shortcuts: _shortcuts,
      debugShowCheckedModeBanner: false,
      theme: IVThemeData.lightThemeData,
      darkTheme: IVThemeData.darkThemeData,
      themeMode: ThemeMode.dark,
      home: ImgViewer(
        filepath: widget.filepath,
      ),
    );
  }
}
