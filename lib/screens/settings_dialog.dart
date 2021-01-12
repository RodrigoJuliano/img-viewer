import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../components/custom_dialog.dart';
import '../providers/settings_provider.dart';

Future showSettingsDialog(BuildContext context) {
  return showCustomDialog(
    title: AppLocalizations.of(context).settingsDialogTitle,
    context: context,
    content: [
      // Builder to allow the use of context.watch
      // And update texts when changing language
      Builder(
        builder: (BuildContext context) {
          final localization = AppLocalizations.of(context);
          return Table(
            defaultColumnWidth: IntrinsicColumnWidth(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: <Widget>[
                  Text(
                    localization.settingsTheme,
                    style: TextStyle(fontSize: 16),
                    softWrap: true,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 40),
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
                      value:
                          context.watch<SettingsProvider>().settings.themeMode,
                      onChanged: (value) {
                        // Updates the value in the settings
                        final provider = context.read<SettingsProvider>();
                        provider.settings =
                            provider.settings.copyWith(themeMode: value);
                      },
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Text(
                    localization.settingsLanguage,
                    style: TextStyle(fontSize: 16),
                    // overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 40),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(
                          child: Text(localization.settingsLanguageEnglish),
                          value: 'en',
                        ),
                        DropdownMenuItem(
                          child: Text(localization.settingsLanguagePortuguese),
                          value: 'pt',
                        ),
                      ],
                      // Gets the value from the settings
                      value:
                          context.watch<SettingsProvider>().settings.language,
                      onChanged: (value) {
                        // Updates the value in the settings
                        final provider = context.read<SettingsProvider>();
                        provider.settings =
                            provider.settings.copyWith(language: value);
                      },
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Text(
                    localization.settingsassociatedWithFileTypes,
                    style: TextStyle(fontSize: 16),
                    // overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 40),
                    child: Checkbox(
                      // Gets the value from the settings
                      value: context
                          .watch<SettingsProvider>()
                          .settings
                          .associatedWithFileTypes,
                      onChanged: (value) {
                        // Updates the value in the settings
                        final provider = context.read<SettingsProvider>();
                        provider.settings = provider.settings
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
                ],
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
