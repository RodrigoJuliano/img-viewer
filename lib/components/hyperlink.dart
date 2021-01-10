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
  bool _hovering = false;

  @override
  void initState() {
    super.initState();

    _hovering = false;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (ev) => setState(() {
        _hovering = true;
      }),
      onExit: (ev) => setState(() {
        _hovering = false;
      }),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: widget.color,
            decoration:
                _hovering ? TextDecoration.underline : TextDecoration.none,
          ),
          text: widget.text != null ? widget.text : widget.link,
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              if (await canLaunch(widget.link)) {
                await launch(
                  widget.link,
                  forceSafariVC: false,
                );
              }
            },
        ),
      ),
    );
  }
}
