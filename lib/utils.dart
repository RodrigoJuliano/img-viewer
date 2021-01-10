import 'package:flutter/material.dart';

String getFileNameFrom(String path) {
  return path.substring(path.lastIndexOf('\\') + 1);
}

class CallbackIntent extends Intent {
  const CallbackIntent({this.callback});

  final VoidCallback callback;
}

String fileSizeHumanReadable(int bytes) {
  var kbs = bytes / 1024;
  if (kbs < 1024) {
    return '${kbs.toStringAsFixed(2)} KBs';
  } else {
    var mbs = kbs / 1024;
    if (mbs < 1024) {
      return '${mbs.toStringAsFixed(2)} MBs';
    } else {
      var gbs = kbs / 1024;
      return '${gbs.toStringAsFixed(2)} GBs';
    }
  }
}
