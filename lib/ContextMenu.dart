import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'ImgViewer.dart';
import 'Utils.dart';
import 'Hyperlink.dart';

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
        return showHelpDialog(context);
        break;
      case ContextItem.aboult:
        return showAboutDialog(context);
        break;
      default:
    }
  });
}

Future<String> showOpenFileDialog() {
  final XTypeGroup imgTypeGroup = XTypeGroup(
    label: 'Image',
    extensions: suported_formats,
  );
  final XTypeGroup allTypeGroup = XTypeGroup(
    label: 'All files',
    extensions: ['*'],
  );

  return openFile(acceptedTypeGroups: [imgTypeGroup, allTypeGroup])
      .then((result) {
    if (result != null && result.path != null)
      return result.path;
    else
      return null;
  });
}

Future showFileInfoDialog(BuildContext context, File curFile) {
  return showCustomDialog(
    title: 'File Info',
    context: context,
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
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(e),
                    ))
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
                  .map((e) => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(e),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    ],
  );
}

Future showHelpDialog(BuildContext context) {
  return showCustomDialog(title: 'Help', context: context, children: []);
}

Future showAboutDialog(BuildContext context) {
  final linkColor = Colors.blueGrey;
  final _spacer = () => SizedBox(
        height: 10,
      );

  return showCustomDialog(title: 'About', context: context, children: [
    Text('Version: v1.0.0'),
    _spacer(),
    Text('Changelog:'),
    Hyperlink(
      color: linkColor,
      link: 'https://github.com/RodrigoJuliano/img-viewer/releases',
    ),
    _spacer(),
    Text('Bug reports and feature requests:'),
    Hyperlink(
      color: linkColor,
      link: 'https://github.com/RodrigoJuliano/img-viewer/issues',
    ),
    _spacer(),
    Text('Source code on Github:'),
    Hyperlink(
      color: linkColor,
      link: 'https://github.com/RodrigoJuliano/img-viewer',
    ),
    _spacer(),
    Text('© 2021 RodrigoJuliano'),
  ]);
}

Future showCustomDialog(
    {String title, BuildContext context, List<Widget> children}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
          title: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Divider(),
            ],
          ),
          contentPadding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 10.0),
          children: children));
}
