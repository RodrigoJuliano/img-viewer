import 'package:flutter/material.dart';

import '../components/custom_dialog.dart';
import '../components/hyperlink.dart';
import '../constants.dart';

Future showAboutDialog(BuildContext context) {
  final linkColor = Theme.of(context).accentColor;
  SizedBox _spacer() => SizedBox(height: 10);

  return showCustomDialog(
    title: 'About',
    context: context,
    content: [
      Text('Version: v1.0.0'),
      _spacer(),
      Text('Changelog:'),
      Hyperlink(
        color: linkColor,
        link: linkChangelog,
      ),
      _spacer(),
      Text('Bug reports and feature requests:'),
      Hyperlink(
        color: linkColor,
        link: linkIssues,
      ),
      _spacer(),
      Text('Source code on Github:'),
      Hyperlink(
        color: linkColor,
        link: linkSource,
      ),
      _spacer(),
      Text('© 2021 RodrigoJuliano'),
    ],
    actions: [
      TextButton(
        child: Text('Licenses'),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => Theme(
                data: Theme.of(context).copyWith(
                  appBarTheme: AppBarTheme(
                    color: Theme.of(context).colorScheme.surface,
                    iconTheme: IconThemeData(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textTheme: Theme.of(context).textTheme,
                  ),
                ),
                child: LicensePage(
                  applicationName: 'ImageViewer',
                  applicationLegalese: '© 2021 RodrigoJuliano',
                ),
              ),
            ),
          );
        },
      ),
      TextButton(
        child: Text('Close'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}
