import 'package:flutter/material.dart';

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
