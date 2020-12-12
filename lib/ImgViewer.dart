import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/services.dart';
import 'CtrlDock.dart';
import 'Utils.dart';
import 'App.dart';
import 'ContextMenu.dart';

const suported_formats = ['png', 'jpg', 'gif', 'webp', 'bmp', 'wbmp', 'ico'];

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
  File curFile;

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

    iniFile(widget.filepath);

    // To execute after fist frame (The App parent is builded after this widget)
    WidgetsBinding.instance.addPostFrameCallback((_) => {
          // Setup the shortcuts
          App.of(context).shortcuts = {
            LogicalKeySet(LogicalKeyboardKey.arrowLeft):
                CallbakIntent(callback: () => goToImg(-1)),
            LogicalKeySet(LogicalKeyboardKey.arrowRight):
                CallbakIntent(callback: () => goToImg(1)),
            LogicalKeySet(LogicalKeyboardKey.arrowUp):
                CallbakIntent(callback: _animateRotLeft),
            LogicalKeySet(LogicalKeyboardKey.arrowDown):
                CallbakIntent(callback: _animateRotRight),
          }
        });
  }

  void iniFile(String filePath) {
    if (filePath != null) {
      setState(() {
        curFile = File(filePath);
        fileFound = curFile.existsSync();
        if (fileFound) {
          imgsCurDir = curFile.parent.listSync().where((f) {
            if (f is File) {
              // Last 5 chars in lowercase
              String _end = f.path
                  .substring(f.path.length - 5, f.path.length)
                  .toLowerCase();
              // Check if it ends with one of the supported extensions
              return suported_formats.any((e) => _end.endsWith('.' + e));
            } else {
              return false;
            }
          }).toList(growable: false);

          curIndex = imgsCurDir.indexWhere((el) => el.path == filePath);
          updateTitle();
        }
      });
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
    appWindow.title = "ImgViewer - " + getFileNameFrom(curFile.path);
  }

  // 1 for the next img, -1 for previous one
  void goToImg(int dir) {
    if (imgsCurDir != null && imgsCurDir.isNotEmpty) {
      resetAllTransf();
      if (dir > 0) {
        setState(() {
          if (curIndex < imgsCurDir.length - 1)
            curIndex++;
          else
            curIndex = 0;

          curFile = imgsCurDir[curIndex];
        });
      } else {
        setState(() {
          if (curIndex > 0)
            curIndex--;
          else
            curIndex = imgsCurDir.length - 1;

          curFile = imgsCurDir[curIndex];
        });
      }
      updateTitle();
    }
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
      body: GestureDetector(
        onDoubleTap: _animateResetInitialize,
        onSecondaryTapUp: (TapUpDetails details) => showContextMenu(
            context: context,
            pos: details.localPosition,
            curFile: curFile,
            onSelectFile: (file) {
              iniFile(file);
              resetAllTransf();
            }),
        child: RotationTransition(
          turns: _rotationController,
          child: InteractiveViewer(
            boundaryMargin: EdgeInsets.all(double.infinity),
            transformationController: _transformationController,
            onInteractionStart: _onInteractionStart,
            maxScale: 100.0,
            minScale: 0.5,
            child: Center(
              child: curFile != null
                  ? Image.file(
                      curFile,
                      scale: 1.0,
                      filterQuality: FilterQuality.none,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        print('Error loading image');
                        print(exception.toString());
                        return Text('The image could not be loaded. 😢');
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: curFile != null
          ? CtrlDock(
              onPressRotLeft: _animateRotLeft,
              onPressRotRight: _animateRotRight,
              onPressPrev: () => goToImg(-1),
              onPressNext: () => goToImg(1))
          : null,
    );
  }
}
