import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ResetableIntViewer extends StatefulWidget {
  ResetableIntViewer({
    Key key,
    this.child,
    @required this.transformationController,
    this.onRightClick,
    this.onDoubleClick,
  }) : super(key: key);
  final Widget child;
  final TransformationController transformationController;
  final void Function(Offset pos) onRightClick;
  final VoidCallback onDoubleClick;

  @override
  _ResetableIntViewerState createState() => _ResetableIntViewerState();
}

class _ResetableIntViewerState extends State<ResetableIntViewer>
    with TickerProviderStateMixin {
  Animation<Matrix4> _animationReset;
  AnimationController _controllerReset;

  void _onAnimateReset() {
    widget.transformationController.value = _animationReset.value;
    if (!_controllerReset.isAnimating) {
      _animationReset?.removeListener(_onAnimateReset);
    }
  }

  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: widget.transformationController.value,
      end: Matrix4.identity(),
    ).animate(_controllerReset);
    _animationReset.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

  @override
  void initState() {
    super.initState();

    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controllerReset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        _animateResetInitialize();
        if (widget.onDoubleClick != null) widget.onDoubleClick();
      },
      onSecondaryTapUp: widget.onRightClick != null
          ? (TapUpDetails details) => widget.onRightClick(details.localPosition)
          : null,
      child: InteractiveViewer(
        boundaryMargin: EdgeInsets.all(double.infinity),
        transformationController: widget.transformationController,
        maxScale: 100.0,
        minScale: 0.5,
        child: Center(child: widget.child),
      ),
    );
  }
}
