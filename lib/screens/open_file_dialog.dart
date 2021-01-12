import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';

Future<String> showOpenFileDialog(BuildContext context) {
  final localization = AppLocalizations.of(context);

  final imgTypeGroup = XTypeGroup(
    label: localization.openFileImageGroup,
    extensions: suportedFormats,
  );
  final allTypeGroup = XTypeGroup(
    label: localization.openFileAllFilesGroup,
    extensions: ['*'],
  );

  return openFile(
    acceptedTypeGroups: [imgTypeGroup, allTypeGroup],
  ).then((result) {
    if (result != null && result.path != null) {
      return result.path;
    } else {
      return null;
    }
  });
}
