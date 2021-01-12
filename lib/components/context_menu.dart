import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

Future showContextMenu({
  BuildContext context,
  Offset pos,
  File curFile,
  void onSelectFile(String file),
}) {
  final localization = AppLocalizations.of(context);

  final contextItens = <PopupMenuEntry<ContextItem>>[
    PopupMenuItem<ContextItem>(
      value: ContextItem.openFile,
      child: Text(localization.contextMenuOpenFile),
      height: 30,
    ),
    PopupMenuItem<ContextItem>(
      value: ContextItem.fileInfo,
      child: Text(localization.contextMenuFileInfo),
      height: 30,
      enabled: curFile != null,
    ),
    const PopupMenuDivider(),
    PopupMenuItem<ContextItem>(
      value: ContextItem.settings,
      child: Text(localization.contextMenuSettings),
      height: 30,
    ),
    PopupMenuItem<ContextItem>(
      value: ContextItem.help,
      child: Text(localization.contextMenuHelp),
      height: 30,
    ),
    PopupMenuItem<ContextItem>(
      value: ContextItem.aboult,
      child: Text(localization.contextMenuAbout),
      height: 30,
    ),
  ];

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
        return showOpenFileDialog(context).then((file) => onSelectFile(file));
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
