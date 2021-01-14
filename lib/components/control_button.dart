import 'package:flutter/material.dart';

import 'deactivable_tootip.dart';

class ControlButton extends StatelessWidget {
  ControlButton({
    this.iconData,
    this.onPress,
    this.tooltip,
  });
  final IconData iconData;
  final VoidCallback onPress;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return DeativableTooltip(
      tooltip: tooltip,
      preferBelow: false,
      child: ElevatedButton(
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
      ),
    );
  }
}
