import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/img_viewer.dart';
import 'utils.dart';
import 'theme/theme_data.dart';
import 'providers/settings_provider.dart';

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
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: Builder(
        builder: (context) {
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
            themeMode: context.watch<SettingsProvider>().settings?.themeMode,
            home: ImgViewer(
              filepath: widget.filepath,
            ),
          );
        },
      ),
    );
  }
}
