import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_chooser/file_chooser.dart';
import 'ImgViewer.dart';
import 'Utils.dart';

enum ContextItem { openFile, fileInfo, help, aboult }

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

Future showContextMenu(
    {BuildContext context,
    Offset pos,
    File curFile,
    void onSelectFile(String file)}) async {
  // Recreate the file info item. It can be enabled or disabled
  contextItens[1] = PopupMenuItem<ContextItem>(
    value: ContextItem.fileInfo,
    child: Text('File info'),
    height: 30,
    enabled: curFile != null,
  );

  return showMenu(
          context: context,
          position: RelativeRect.fromLTRB(pos.dx, pos.dy, pos.dx, pos.dy),
          items: contextItens)
      .then((selection) {
    switch (selection) {
      case ContextItem.openFile:
        return showOpenFileDialog().then((file) => onSelectFile(file));
        break;
      case ContextItem.fileInfo:
        return showFileInfoDialog(context, curFile);
        break;
      case ContextItem.help:
        break;
      case ContextItem.aboult:
        break;
      default:
    }
  });
}

Future<String> showOpenFileDialog() {
  return showOpenPanel(allowedFileTypes: [
    FileTypeFilterGroup(label: 'Image', fileExtensions: suported_formats),
    FileTypeFilterGroup(label: 'All files'),
  ]).then((result) {
    if (!result.canceled && result.paths.isNotEmpty)
      return result.paths[0];
    else
      return null;
  });
}

Future showFileInfoDialog(BuildContext context, File curFile) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => SimpleDialog(
      title: Column(
        children: [
          Text(
            'File Info',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Divider(),
        ],
      ),
      contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                'Name:',
                'Directory:',
                'Type:',
                'Size:',
                'Modified:',
              ]
                  .map((e) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(e),
                      ))
                  .toList(),
            ),
            Divider(indent: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getFileNameFrom(curFile.path),
                  curFile.absolute.path
                      .substring(0, curFile.absolute.path.lastIndexOf('\\')),
                  curFile.path.substring(curFile.path.lastIndexOf('.') + 1),
                  fileSizeHumanReadable(curFile.lengthSync()),
                  curFile.lastModifiedSync().toString(),
                ]
                    .map((e) => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(e),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}