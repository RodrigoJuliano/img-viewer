import 'package:flutter/material.dart';

String getFileNameFrom(String path) {
  return path.substring(path.lastIndexOf('\\') + 1);
}

class CallbakIntent extends Intent {
  const CallbakIntent({this.callback});

  final VoidCallback callback;
}
