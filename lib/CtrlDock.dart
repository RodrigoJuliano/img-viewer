import 'package:flutter/material.dart';
import 'CtrlButton.dart';

class CtrlDock extends StatefulWidget {
  CtrlDock({
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
  _CtrlDockState createState() => _CtrlDockState();
}

/// This is the private State class that goes with AnimatedCtrl.
class _CtrlDockState extends State<CtrlDock>
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CtrlButton(
                iconData: Icons.arrow_back,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
                onPress: widget.onPressPrev,
              ),
              CtrlButton(
                iconData: Icons.rotate_left,
                borderRadius: BorderRadius.zero,
                onPress: widget.onPressRotLeft,
              ),
              CtrlButton(
                iconData: Icons.rotate_right,
                borderRadius: BorderRadius.zero,
                onPress: widget.onPressRotRight,
              ),
              CtrlButton(
                iconData: Icons.arrow_forward,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                onPress: widget.onPressNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
