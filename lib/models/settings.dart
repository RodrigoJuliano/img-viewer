import 'package:flutter/material.dart';

class Settings {
  final ThemeMode themeMode;
  final bool associatedWithFileTypes;
  final String language;
  final FilterQuality filterQuality;
  final bool showTooltips;

  Settings({
    this.themeMode = ThemeMode.dark,
    this.associatedWithFileTypes = false,
    this.language = 'en',
    this.filterQuality = FilterQuality.low,
    this.showTooltips = true,
  });

  Settings.fromJson(Map<String, dynamic> json)
      : themeMode = ThemeMode.values[json['themeMode'] ?? 1],
        associatedWithFileTypes = json['associatedWithFileTypes'] ?? false,
        language = json['language'] ?? 'en',
        filterQuality = FilterQuality.values[json['filterQuality'] ?? 1],
        showTooltips = json['showTooltips'] ?? false;

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode.index,
        'associatedWithFileTypes': associatedWithFileTypes,
        'language': language,
        'filterQuality': filterQuality.index,
        'showTooltips': showTooltips,
      };

  Settings copyWith({
    ThemeMode themeMode,
    bool associatedWithFileTypes,
    String language,
    FilterQuality filterQuality,
    bool showTooltips,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      associatedWithFileTypes:
          associatedWithFileTypes ?? this.associatedWithFileTypes,
      language: language ?? this.language,
      filterQuality: filterQuality ?? this.filterQuality,
      showTooltips: showTooltips ?? this.showTooltips,
    );
  }
}
