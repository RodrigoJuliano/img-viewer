import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  final ThemeMode themeMode;
  final bool associatedWithFileTypes;

  Settings({
    this.themeMode = ThemeMode.dark,
    this.associatedWithFileTypes = false,
  });

  Settings.fromJson(Map<String, dynamic> json)
      : themeMode = ThemeMode.values[json['themeMode'] ?? 1],
        associatedWithFileTypes = json['associatedWithFileTypes'] ?? false;

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode.index,
        'associatedWithFileTypes': associatedWithFileTypes,
      };

  Settings copyWith({ThemeMode themeMode, bool associatedWithFileTypes}) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      associatedWithFileTypes:
          associatedWithFileTypes ?? this.associatedWithFileTypes,
    );
  }
}

class SettingsProvider with ChangeNotifier {
  var _settings = Settings();

  SettingsProvider() {
    syncDataWithProvider();
  }

  Settings get settings => _settings;

  set settings(Settings settings) {
    _settings = settings;
    updateSharedPrefrences();
    notifyListeners();
  }

  Future updateSharedPrefrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings', json.encode(_settings.toJson()));
  }

  Future syncDataWithProvider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getString('settings');

    if (result != null) {
      _settings = Settings.fromJson(json.decode(result));
    }

    notifyListeners();
  }
}
