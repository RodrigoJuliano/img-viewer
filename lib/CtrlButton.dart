import 'package:flutter/material.dart';

class CtrlButton extends StatelessWidget {
  CtrlButton({
    this.iconData,
    this.onPress,
  });
  final IconData iconData;
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
                borderRadius: BorderRadius.zero,
              ),
            ),
            elevation: MaterialStateProperty.all(0.0),
          ),
    );
  }
}
