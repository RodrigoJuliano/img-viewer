import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../components/custom_dialog.dart';
import '../providers/settings_provider.dart';

Future showSettingsDialog(BuildContext context) {
  return showCustomDialog(
    title: 'Settings',
    context: context,
    content: [
      Table(
        defaultColumnWidth: IntrinsicColumnWidth(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: <Widget>[
              Text(
                'Theme',
                style: TextStyle(fontSize: 16),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 40),
                child: Builder(
                  // Builder to allow the use of context.watch
                  builder: (BuildContext context) {
                    return DropdownButton<ThemeMode>(
                      items: [
                        DropdownMenuItem(
                          child: Text('Dark'),
                          value: ThemeMode.dark,
                        ),
                        DropdownMenuItem(
                          child: Text('Light'),
                          value: ThemeMode.light,
                        ),
                        DropdownMenuItem(
                          child: Text('System'),
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
                    );
                  },
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              Text(
                'Associate with suported files',
                style: TextStyle(fontSize: 16),
                // overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 40),
                child: Builder(
                  // Builder to allow the use of context.watch
                  builder: (BuildContext context) {
                    return Checkbox(
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
                          // To execute them in other modes, some adaptations are necessary
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
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      )
    ],
    actions: [
      TextButton(
        child: Text('Close'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}
