import 'package:flutter/material.dart';

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
