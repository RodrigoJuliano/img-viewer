import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ResetableInteractiveViewer extends StatefulWidget {
  ResetableInteractiveViewer({
    Key key,
    this.child,
    this.onRightClick,
    this.onDoubleClick,
  }) : super(key: key);
  final Widget child;
  final void Function(Offset pos) onRightClick;
  final VoidCallback onDoubleClick;

  @override
  _ResetableInteractiveViewerState createState() =>
      _ResetableInteractiveViewerState();
}

class _ResetableInteractiveViewerState extends State<ResetableInteractiveViewer>
    with TickerProviderStateMixin {
  Animation<Matrix4> _animationReset;
  AnimationController _controllerReset;

  final TransformationController _transformationController =
      TransformationController();

  void _onAnimateReset() {
    _transformationController.value = _animationReset.value;
    if (!_controllerReset.isAnimating) {
      _animationReset?.removeListener(_onAnimateReset);
    }
  }

  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
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
        transformationController: _transformationController,
        maxScale: 100.0,
        minScale: 0.5,
        child: Center(child: widget.child),
      ),
    );
  }
}
