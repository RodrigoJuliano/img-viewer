import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

class Hyperlink extends StatefulWidget {
  Hyperlink({
    Key key,
    this.color,
    this.text,
    @required this.link,
  }) : super(key: key);

  final Color color;
  final String text;
  final String link;

  @override
  _HyperlinkState createState() => _HyperlinkState();
}

class _HyperlinkState extends State<Hyperlink> {
  bool _isHovered;
  bool _isFocused;

  @override
  void initState() {
    super.initState();

    _isHovered = false;
    _isFocused = false;
  }

  void onActivate() async {
    if (await canLaunch(widget.link)) {
      await launch(
        widget.link,
        forceSafariVC: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      actions: {
        ...WidgetsApp.defaultActions,
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (ActivateIntent intent) {
            onActivate();
            return null;
          },
        ),
      },
      onShowHoverHighlight: (hovered) {
        setState(() {
          _isHovered = hovered;
        });
      },
      onShowFocusHighlight: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      child: Container(
        color: _isFocused
            ? Theme.of(context).accentColor.withAlpha(50)
            : Colors.transparent,
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              color: widget.color,
              decoration: _isHovered || _isFocused
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
            text: widget.text != null ? widget.text : widget.link,
            recognizer: TapGestureRecognizer()..onTap = onActivate,
          ),
        ),
      ),
    );
  }
}
