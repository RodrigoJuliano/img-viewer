import 'package:flutter/material.dart';

class Settings {
  final ThemeMode themeMode;
  final bool associatedWithFileTypes;
  final String language;

  Settings({
    this.themeMode = ThemeMode.dark,
    this.associatedWithFileTypes = false,
    this.language = 'en',
  });

  Settings.fromJson(Map<String, dynamic> json)
      : themeMode = ThemeMode.values[json['themeMode'] ?? 1],
        associatedWithFileTypes = json['associatedWithFileTypes'] ?? false,
        language = json['language'] ?? 'en';

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode.index,
        'associatedWithFileTypes': associatedWithFileTypes,
        'language': language
      };

  Settings copyWith({
    ThemeMode themeMode,
    bool associatedWithFileTypes,
    String language,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      associatedWithFileTypes:
          associatedWithFileTypes ?? this.associatedWithFileTypes,
      language: language ?? this.language,
    );
  }
}
