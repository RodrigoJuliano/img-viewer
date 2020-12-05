import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

const suported_formats = [
  '.png',
  '.jpg',
  '.gif',
  '.webp',
  '.bmp',
  '.wbmp',
  '.ico'
];

void main(List<String> args) {
  String filepath;
  if (args != null && args.isNotEmpty) {
    filepath = args[0];
  }
  runApp(MyApp(filepath));

  doWhenWindowReady(() {
    // var win = appWindow;
    appWindow.minSize = Size(400, 300);
    appWindow.alignment = Alignment.center;
    // win.title = "Custom window with Flutter";
    appWindow.show();
  });
}

String getFileNameFrom(String path) {
  return path.substring(path.lastIndexOf('\\') + 1);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp(this.filepath);
  final String filepath;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImgViewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyStatefulWidget(filepath: filepath),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key, this.filepath}) : super(key: key);

  final String filepath;

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
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
      floatingActionButton: AnimatedCtrl(
          onPressCenter: _animateResetInitialize,
          onPressRotLeft: _animateRotLeft,
          onPressRotRight: _animateRotRight,
          onPressPrev: goPrevImg,
          onPressNext: goNextImg),
    );
  }
}

class CtrlButton extends FlatButton {
  CtrlButton({this.iconData, this.borderRadius, this.onPress});
  final IconData iconData;
  final BorderRadius borderRadius;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      minWidth: 0,
      child: Icon(
        iconData,
        color: Colors.grey[600],
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      onPressed: onPress,
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
    );
  }
}

class AnimatedCtrl extends StatefulWidget {
  AnimatedCtrl(
      {Key key,
      this.onPressCenter,
      this.onPressRotLeft,
      this.onPressRotRight,
      this.onPressPrev,
      this.onPressNext})
      : super(key: key);

  final void Function() onPressCenter;
  final void Function() onPressRotLeft;
  final void Function() onPressRotRight;
  final void Function() onPressPrev;
  final void Function() onPressNext;

  @override
  _AnimatedCtrlState createState() => _AnimatedCtrlState();
}

/// This is the private State class that goes with AnimatedCtrl.
class _AnimatedCtrlState extends State<AnimatedCtrl>
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
                    bottomLeft: Radius.circular(25)),
                onPress: widget.onPressPrev,
              ),
              CtrlButton(
                iconData: Icons.rotate_left,
                borderRadius: BorderRadius.zero,
                onPress: widget.onPressRotLeft,
              ),
              // CtrlButton(
              //   iconData: Icons.center_focus_weak_outlined,
              //   borderRadius: BorderRadius.zero,
              //   onPress: widget.onPressCenter,
              // ),
              CtrlButton(
                iconData: Icons.rotate_right,
                borderRadius: BorderRadius.zero,
                onPress: widget.onPressRotRight,
              ),
              CtrlButton(
                iconData: Icons.arrow_forward,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
                onPress: widget.onPressNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
