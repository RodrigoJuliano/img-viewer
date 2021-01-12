import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/settings_provider.dart';
import 'screens/img_viewer.dart';
import 'theme/theme_data.dart' as theme;
import 'utils.dart';

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

  Map<LogicalKeySet, Intent> get shortcuts => _shortcuts;

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
            theme: theme.lightThemeData,
            darkTheme: theme.darkThemeData,
            themeMode: context.watch<SettingsProvider>().settings?.themeMode,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''), // English, no country code
              const Locale('pt', ''), // Portuguese, no country code
            ],
            locale: Locale(context.watch<SettingsProvider>().settings.language),
            home: ImgViewer(
              filepath: widget.filepath,
            ),
          );
        },
      ),
    );
  }
}
