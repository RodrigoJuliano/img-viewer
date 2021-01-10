import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';

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
