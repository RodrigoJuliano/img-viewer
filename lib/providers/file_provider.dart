import 'dart:io';

import 'package:flutter/material.dart';

class FileProvider extends ChangeNotifier {
  File _curFile;
  int _indexCurFile;
  List<FileSystemEntity> _fileList = [];

  File get curFile => _curFile;

  void setInitialFile(String filePath, List<String> extensions) {
    _curFile = File(filePath);

    // Get the list of files with desired extensions in the directory
    _fileList = curFile.parent.listSync().where(
      (f) {
        if (f is File) {
          // Get the extension
          var ext = f.path.substring(f.path.lastIndexOf('.') + 1)
            ..toLowerCase();
          // Check if it is desired
          return extensions.any((e) => ext == e);
        } else {
          return false;
        }
      },
    ).toList(growable: false);

    _indexCurFile = _fileList.indexWhere((el) => el.path == filePath);

    notifyListeners();
  }

  bool goNextFile() {
    // There is no next file
    if (_fileList.length < 2) return false;

    if (_indexCurFile < _fileList.length - 1) {
      _indexCurFile++;
    } else {
      _indexCurFile = 0;
    }
    _curFile = _fileList[_indexCurFile];

    notifyListeners();
    return true;
  }

  bool goPreviousFile() {
    // There is no previous file
    if (_fileList.length < 2) return false;

    if (_indexCurFile > 0) {
      _indexCurFile--;
    } else {
      _indexCurFile = _fileList.length - 1;
    }
    _curFile = _fileList[_indexCurFile];

    notifyListeners();
    return true;
  }
}
