import 'dart:io';

import 'package:flutter/material.dart';

import '../components/custom_dialog.dart';
import '../utils.dart';

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
