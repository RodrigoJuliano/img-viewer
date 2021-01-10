import 'package:flutter/material.dart';

import '../components/custom_dialog.dart';

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
