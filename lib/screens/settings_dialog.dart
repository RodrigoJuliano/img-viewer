import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../components/custom_dialog.dart';
import '../components/deactivable_tootip.dart';
import '../providers/settings_provider.dart';

Future showSettingsDialog(BuildContext context) {
  return showCustomDialog(
    title: Builder(
      builder: (BuildContext context) {
        return Text(AppLocalizations.of(context).settingsDialogTitle);
      },
    ),
    context: context,
    content: [
      // Builder to allow the use of context.watch
      // And update texts when changing language
      Builder(
        builder: (BuildContext context) {
          final localization = AppLocalizations.of(context);
          final settingsProvider = Provider.of<SettingsProvider>(context);
          return Column(
            children: [
              _Tile(
                label: localization.settingsTheme,
                tooltip: localization.settingsThemeTooltip,
                option: DropdownButtonHideUnderline(
                  child: DropdownButton<ThemeMode>(
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        child: Text(localization.settingsThemeDark),
                        value: ThemeMode.dark,
                      ),
                      DropdownMenuItem(
                        child: Text(localization.settingsThemeLight),
                        value: ThemeMode.light,
                      ),
                      DropdownMenuItem(
                        child: Text(localization.settingsThemeSystem),
                        value: ThemeMode
                            .system, // Currently does not work on Windows
                      ),
                    ],
                    // Gets the value from the settings
                    value: settingsProvider.settings.themeMode,
                    onChanged: (value) {
                      // Updates the value in the settings
                      settingsProvider.settings =
                          settingsProvider.settings.copyWith(themeMode: value);
                    },
                  ),
                ),
              ),
              Divider(indent: 0, endIndent: 0),
              _Tile(
                label: localization.settingsFilterQuality,
                tooltip: localization.settingsFilterQualityTooltip,
                option: DropdownButtonHideUnderline(
                  child: DropdownButton<FilterQuality>(
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          localization.settingsFilterQualityHigh,
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: FilterQuality.high,
                      ),
                      DropdownMenuItem(
                        child: Text(
                          localization.settingsFilterQualityMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: FilterQuality.medium,
                      ),
                      DropdownMenuItem(
                        child: Text(
                          localization.settingsFilterQualityLow,
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: FilterQuality.low,
                      ),
                      DropdownMenuItem(
                        child: Text(
                          localization.settingsFilterQualityNone,
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: FilterQuality.none,
                      ),
                    ],
                    // Gets the value from the settings
                    value: settingsProvider.settings.filterQuality,
                    onChanged: (value) {
                      // Updates the value in the settings
                      settingsProvider.settings = settingsProvider.settings
                          .copyWith(filterQuality: value);
                    },
                  ),
                ),
              ),
              Divider(indent: 0, endIndent: 0),
              _Tile(
                label: localization.settingsLanguage,
                tooltip: localization.settingsLanguageTooltip,
                option: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          localization.settingsLanguageEnglish,
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: 'en',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          localization.settingsLanguagePortuguese,
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: 'pt',
                      ),
                    ],
                    // Gets the value from the settings
                    value: settingsProvider.settings.language,
                    onChanged: (value) {
                      // Updates the value in the settings
                      settingsProvider.settings =
                          settingsProvider.settings.copyWith(language: value);
                    },
                  ),
                ),
              ),
              Divider(indent: 0, endIndent: 0),
              _Tile(
                label: localization.settingsAssociatedWithFileTypes,
                tooltip: localization.settingsAssociatedWithFileTypesTooltip,
                option: Checkbox(
                  // Gets the value from the settings
                  value: settingsProvider.settings.associatedWithFileTypes,
                  onChanged: (value) {
                    // Updates the value in the settings
                    settingsProvider.settings = settingsProvider.settings
                        .copyWith(associatedWithFileTypes: value);

                    // Run the (un)installation script
                    try {
                      // Run scripts only in release mode
                      // To execute them in other modes, some adaptations
                      // are necessary
                      if (Platform.isWindows && kReleaseMode) {
                        Process.run(
                          value
                              ? 'scripts\\install.bat'
                              : 'scripts\\uninstall.bat',
                          [],
                        ).then(
                          (ProcessResult result) {
                            print(result.exitCode);
                            print(result.stdout);
                            print(result.stderr);
                          },
                        );
                      }
                    } on ProcessException catch (e) {
                      print(e?.message);
                    }
                  },
                ),
              ),
              Divider(indent: 0, endIndent: 0),
              _Tile(
                label: localization.settingsShowTooltips,
                tooltip: localization.settingsShowTooltipsTooltip,
                option: Checkbox(
                  // Gets the value from the settings
                  value: settingsProvider.settings.showTooltips,
                  onChanged: (value) {
                    // Updates the value in the settings
                    settingsProvider.settings =
                        settingsProvider.settings.copyWith(showTooltips: value);
                  },
                ),
              ),
            ],
          );
        },
      ),
    ],
    actions: [
      TextButton(
        // Builder to update the text when changing language
        child: Builder(
          builder: (BuildContext context) {
            return Text(AppLocalizations.of(context).dialogCloseButton);
          },
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}

class _Tile extends StatelessWidget {
  _Tile({
    Key key,
    @required this.label,
    @required this.option,
    this.tooltip,
  }) : super(key: key);

  final String label;
  final Widget option;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return DeativableTooltip(
      tooltip: tooltip,
      child: SizedBox(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              width: 110,
              child: option,
            ),
          ],
        ),
      ),
    );
  }
}
