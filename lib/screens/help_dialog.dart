import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/custom_dialog.dart';

Future showHelpDialog(BuildContext context) {
  final localization = AppLocalizations.of(context);
  return showCustomDialog(
    title: Text(localization.helpDialogTitle),
    context: context,
    content: [],
    actions: [
      TextButton(
        child: Text(localization.dialogCloseButton),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}
