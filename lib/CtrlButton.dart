import 'package:flutter/material.dart';

class CtrlButton extends StatelessWidget {
  CtrlButton({
    this.iconData,
    this.borderRadius,
    this.onPress,
  });
  final IconData iconData;
  final BorderRadius borderRadius;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 7,
          horizontal: 5,
        ),
        child: Icon(
          iconData,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      onPressed: onPress,
      style: Theme.of(context).elevatedButtonTheme.style.copyWith(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
            ),
          ),
    );
  }
}
