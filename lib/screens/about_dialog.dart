import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/custom_dialog.dart';
import '../components/hyperlink.dart';
import '../constants.dart';

Future showAboutDialog(BuildContext context) {
  final linkColor = Theme.of(context).accentColor;
  SizedBox _spacer() => SizedBox(height: 10);

  final localization = AppLocalizations.of(context);

  const legalese = '© 2021 RodrigoJuliano';

  return showCustomDialog(
    title: Text(localization.aboutDialogTitle),
    context: context,
    content: [
      Text('${localization.aboutVersion} $version'),
      _spacer(),
      Text(localization.aboutChangelog),
      Hyperlink(
        color: linkColor,
        link: linkChangelog,
      ),
      _spacer(),
      Text(localization.aboutBugReportsFeatureRequests),
      Hyperlink(
        color: linkColor,
        link: linkIssues,
      ),
      _spacer(),
      Text(localization.aboutSourceCodeGithub),
      Hyperlink(
        color: linkColor,
        link: linkSource,
      ),
      _spacer(),
      Text(legalese),
    ],
    actions: [
      TextButton(
        child: Text(localization.aboutLicensesButton),
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
                  applicationLegalese: legalese,
                ),
              ),
            ),
          );
        },
      ),
      TextButton(
        child: Text(localization.dialogCloseButton),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}
