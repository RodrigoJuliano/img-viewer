import 'package:flutter/material.dart';
import 'ImgViewer.dart';
import 'Utils.dart';

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
        CallbakIntent: CallbackAction<CallbakIntent>(
          onInvoke: (CallbakIntent intent) {
            return intent.callback();
          },
        ),
      },
      shortcuts: _shortcuts,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        dialogTheme: DialogTheme(
          backgroundColor: Colors.grey[900],
          titleTextStyle: TextStyle(color: Colors.grey[400]),
          // contentTextStyle:
        ),
        dividerColor: Colors.black45,
        dividerTheme: DividerThemeData(endIndent: 5, indent: 5),
        textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.grey[400], fontSize: 16),
            subtitle1: TextStyle(color: Colors.grey[400], fontSize: 16),
            headline6: TextStyle(color: Colors.grey[400])),
      ),
      home: ImgViewer(filepath: widget.filepath),
    );
  }
}
