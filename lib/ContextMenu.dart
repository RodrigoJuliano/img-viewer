import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:provider/provider.dart';
import 'ImgViewer.dart';
import 'Utils.dart';
import 'Hyperlink.dart';
import 'Settings.dart';

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
}) async {
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

  return openFile(
    acceptedTypeGroups: [imgTypeGroup, allTypeGroup],
  ).then((result) {
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
    content: [
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
        child: Text('Close'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}

Future showHelpDialog(BuildContext context) {
  return showCustomDialog(
    title: 'Help',
    context: context,
    content: [],
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

Future showAboutDialog(BuildContext context) {
  final linkColor = Theme.of(context).accentColor;
  final _spacer = () => SizedBox(height: 10);

  final linkChangelog = 'https://github.com/RodrigoJuliano/img-viewer/releases';
  final linkIssues = 'https://github.com/RodrigoJuliano/img-viewer/issues';
  final linkSource = 'https://github.com/RodrigoJuliano/img-viewer';

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
                      value:
                          context.watch<SettingsProvider>().settings.themeMode,
                      onChanged: (value) {
                        var provider = context.read<SettingsProvider>();
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
            decoration: BoxDecoration(),
            children: [
              Text(
                'Associate with suported files',
                style: TextStyle(fontSize: 16),
                // overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 40),
                child: Checkbox(value: true, onChanged: (value) {}),
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

Future showCustomDialog({
  @required String title,
  @required BuildContext context,
  List<Widget> content = const [],
  List<Widget> actions = const [],
}) {
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
          Divider(
            indent: 0,
            endIndent: 0,
          ),
        ],
      ),
      contentPadding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 10.0),
      children: [
        ...content,
        Wrap(
          alignment: WrapAlignment.end,
          spacing: 5,
          children: actions,
        ),
      ],
    ),
  );
}
