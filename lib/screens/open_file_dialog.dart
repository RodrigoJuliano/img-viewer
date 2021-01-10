import 'package:file_selector/file_selector.dart';

import '../constants.dart';

Future<String> showOpenFileDialog() {
  final imgTypeGroup = XTypeGroup(
    label: 'Image',
    extensions: suportedFormats,
  );
  final allTypeGroup = XTypeGroup(
    label: 'All files',
    extensions: ['*'],
  );

  return openFile(
    acceptedTypeGroups: [imgTypeGroup, allTypeGroup],
  ).then((result) {
    if (result != null && result.path != null) {
      return result.path;
    } else {
      return null;
    }
  });
}
