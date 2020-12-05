import 'package:flutter/material.dart';

class CtrlButton extends FlatButton {
  CtrlButton({this.iconData, this.borderRadius, this.onPress});
  final IconData iconData;
  final BorderRadius borderRadius;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      minWidth: 0,
      child: Icon(
        iconData,
        color: Colors.grey[600],
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      onPressed: onPress,
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
    );
  }
}
