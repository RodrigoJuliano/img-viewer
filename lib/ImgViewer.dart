import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'CtrlDock.dart';
import 'Utils.dart';

const suported_formats = [
  '.png',
  '.jpg',
  '.gif',
  '.webp',
  '.bmp',
  '.wbmp',
  '.ico'
];

/// This is the stateful widget that the main application instantiates.
class ImgViewer extends StatefulWidget {
  ImgViewer({Key key, this.filepath}) : super(key: key);

  final String filepath;

  @override
  _ImgViewerState createState() => _ImgViewerState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _ImgViewerState extends State<ImgViewer> with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  Animation<Matrix4> _animationReset;
  AnimationController _controllerReset;

  AnimationController _rotationController;
  bool fileFound = false;
  List<FileSystemEntity> imgsCurDir;
  int curIndex;

  void _onAnimateReset() {
    _transformationController.value = _animationReset.value;
    if (!_controllerReset.isAnimating) {
      _animationReset?.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
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

// Stop a running reset to home transform animation.
  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  void _animateRotLeft() {
    if (!_rotationController.isAnimating) {
      if (_rotationController.value == 0) {
        _rotationController.value = 1;
      }
      _rotationController.animateTo(_rotationController.value - 0.25);
    }
  }

  void _animateRotRight() {
    if (!_rotationController.isAnimating) {
      if (_rotationController.value == 1) {
        _rotationController.value = 0;
      }
      _rotationController.animateTo(_rotationController.value + 0.25);
    }
  }

  @override
  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    if (widget.filepath != null) {
      File file = File(widget.filepath);
      fileFound = file.existsSync();
      if (fileFound) {
        imgsCurDir = file.parent.listSync().where((f) {
          if (f is File) {
            // Last 5 chars in lowercase
            String _end = f.path
                .substring(f.path.length - 5, f.path.length)
                .toLowerCase();
            // Check if it ends with one of the supported extensions
            return suported_formats.any((e) => _end.endsWith(e));
          } else {
            return false;
          }
        }).toList(growable: false);

        curIndex = imgsCurDir.indexWhere((el) => el.path == widget.filepath);
        updateTitle();
      }
    }
  }

  void resetAllTransf() {
    // Zoom
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
    _transformationController.value = Matrix4.identity();

    // Rotation
    _rotationController.reset();
  }

  void updateTitle() {
    appWindow.title =
        "ImgViewer - " + getFileNameFrom(imgsCurDir[curIndex].path);
  }

  void goNextImg() {
    resetAllTransf();
    setState(() {
      if (curIndex < imgsCurDir.length - 1)
        curIndex++;
      else
        curIndex = 0;
    });
    updateTitle();
  }

  void goPrevImg() {
    resetAllTransf();
    setState(() {
      if (curIndex > 0)
        curIndex--;
      else
        curIndex = imgsCurDir.length - 1;
    });
    updateTitle();
  }

  @override
  void dispose() {
    _controllerReset.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: fileFound
          ? GestureDetector(
              onDoubleTap: _animateResetInitialize,
              child: RotationTransition(
                turns: _rotationController,
                child: InteractiveViewer(
                  boundaryMargin: EdgeInsets.all(double.infinity),
                  transformationController: _transformationController,
                  onInteractionStart: _onInteractionStart,
                  maxScale: 100.0,
                  minScale: 0.5,
                  child: Center(
                      child: Image.file(
                    imgsCurDir[curIndex],
                    scale: 1.0,
                    filterQuality: FilterQuality.none,
                  )),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CtrlDock(
          onPressCenter: _animateResetInitialize,
          onPressRotLeft: _animateRotLeft,
          onPressRotRight: _animateRotRight,
          onPressPrev: goPrevImg,
          onPressNext: goNextImg),
    );
  }
}
