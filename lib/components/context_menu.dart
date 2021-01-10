import 'dart:io';

import 'package:flutter/material.dart';

import '../screens/about_dialog.dart' as about;
import '../screens/file_info_dialog.dart';
import '../screens/help_dialog.dart';
import '../screens/open_file_dialog.dart';
import '../screens/settings_dialog.dart';

enum ContextItem {
  openFile,
  fileInfo,
  settings,
  help,
  aboult,
}

List<PopupMenuEntry<ContextItem>> contextItens = [
  const PopupMenuItem<ContextItem>(
    value: ContextItem.openFile,
    child: Text('Open file'),
    height: 30,
  ),
  // Placeholder for file info
  const PopupMenuItem<ContextItem>(
    child: null,
  ),
  const PopupMenuDivider(),
  const PopupMenuItem<ContextItem>(
    value: ContextItem.settings,
    child: Text('Settings'),
    height: 30,
  ),
  const PopupMenuItem<ContextItem>(
    value: ContextItem.help,
    child: Text('Help'),
    height: 30,
  ),
  const PopupMenuItem<ContextItem>(
    value: ContextItem.aboult,
    child: Text('About'),
    height: 30,
  ),
];

Future showContextMenu({
  BuildContext context,
  Offset pos,
  File curFile,
  void onSelectFile(String file),
}) {
  // Recreate the file info item. It can be enabled or disabled
  contextItens[1] = PopupMenuItem<ContextItem>(
    value: ContextItem.fileInfo,
    child: Text('File info'),
    height: 30,
    enabled: curFile != null,
  );

  return showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      pos.dx,
      pos.dy,
      pos.dx,
      pos.dy,
    ),
    items: contextItens,
  ).then((selection) {
    switch (selection) {
      case ContextItem.openFile:
        return showOpenFileDialog().then((file) => onSelectFile(file));
        break;
      case ContextItem.fileInfo:
        return showFileInfoDialog(context, curFile);
        break;
      case ContextItem.settings:
        return showSettingsDialog(context);
        break;
      case ContextItem.help:
        return showHelpDialog(context);
        break;
      case ContextItem.aboult:
        return about.showAboutDialog(context);
        break;
      default:
    }
  });
}
