import 'package:flutter/material.dart';

Future showCustomDialog({
  @required Widget title,
  @required BuildContext context,
  List<Widget> content = const [],
  List<Widget> actions = const [],
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => SimpleDialog(
      title: DefaultTextStyle(
        child: title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
      titlePadding: EdgeInsets.all(20),
      contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
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
