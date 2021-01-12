import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/custom_dialog.dart';
import '../utils.dart';

Future showFileInfoDialog(BuildContext context, File curFile) {
  final localization = AppLocalizations.of(context);

  return showCustomDialog(
    title: localization.fileInfoDialogTitle,
    context: context,
    content: [
      Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              localization.fileInfoName,
              localization.fileInfoDirectory,
              localization.fileInfoType,
              localization.fileInfoSize,
              localization.fileInfoModified,
            ]
                .map(
                  (e) => Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(e),
                  ),
                )
                .toList(),
          ),
          Divider(indent: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                getFileNameFrom(curFile.path),
                // Directory
                curFile.absolute.path
                    .substring(0, curFile.absolute.path.lastIndexOf('\\')),
                // Type
                curFile.path.substring(curFile.path.lastIndexOf('.') + 1),
                // Size
                fileSizeHumanReadable(curFile.lengthSync()),
                // Modified
                curFile.lastModifiedSync().toString().split('.')[0],
              ]
                  .map(
                    (e) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(e),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    ],
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
