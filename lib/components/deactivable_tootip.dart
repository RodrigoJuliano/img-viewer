import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class DeativableTooltip extends StatelessWidget {
  DeativableTooltip({
    Key key,
    this.tooltip,
    this.preferBelow = true,
    @required this.child,
  }) : super(key: key);

  final String tooltip;
  final bool preferBelow;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var settings = context.watch<SettingsProvider>().settings;
    return tooltip != null && settings.showTooltips
        ? Tooltip(
            message: tooltip,
            child: child,
            preferBelow: preferBelow,
          )
        : child;
  }
}
