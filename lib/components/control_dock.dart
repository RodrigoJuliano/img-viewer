import 'package:flutter/material.dart';
import 'control_button.dart';

class ControlDock extends StatefulWidget {
  ControlDock({
    Key key,
    this.onPressRotLeft,
    this.onPressRotRight,
    this.onPressPrev,
    this.onPressNext,
  }) : super(key: key);

  final VoidCallback onPressRotLeft;
  final VoidCallback onPressRotRight;
  final VoidCallback onPressPrev;
  final VoidCallback onPressNext;

  @override
  _ControlDockState createState() => _ControlDockState();
}

/// This is the private State class that goes with AnimatedCtrl.
class _ControlDockState extends State<ControlDock>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..reverse();

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEvent pe) => {
        _controller.forward(),
      },
      onExit: (PointerEvent pe) => {
        _controller.reverse(),
      },
      child: Container(
        width: 300,
        height: 100,
        // color: Colors.red,
        child: SlideTransition(
          position: _offsetAnimation,
          child: FittedBox(
            fit: BoxFit.none,
            child: Material(
              clipBehavior: Clip.antiAlias,
              elevation: 10,
              borderRadius: BorderRadius.all(Radius.circular(25)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ControlButton(
                    iconData: Icons.arrow_back,
                    onPress: widget.onPressPrev,
                  ),
                  ControlButton(
                    iconData: Icons.rotate_left,
                    onPress: widget.onPressRotLeft,
                  ),
                  ControlButton(
                    iconData: Icons.rotate_right,
                    onPress: widget.onPressRotRight,
                  ),
                  ControlButton(
                    iconData: Icons.arrow_forward,
                    onPress: widget.onPressNext,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
