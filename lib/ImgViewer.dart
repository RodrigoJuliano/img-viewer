import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/services.dart';
import 'CtrlDock.dart';
import 'Utils.dart';
import 'App.dart';
import 'package:file_chooser/file_chooser.dart';

const suported_formats = ['png', 'jpg', 'gif', 'webp', 'bmp', 'wbmp', 'ico'];

enum ContextItem { openFile, fileInfo, help, aboult }

const List<PopupMenuEntry<ContextItem>> contextItens = [
  const PopupMenuItem<ContextItem>(
    value: ContextItem.openFile,
    child: Text('Open file'),
    height: 30,
  ),
  const PopupMenuItem<ContextItem>(
    value: ContextItem.fileInfo,
    child: Text('File info'),
    height: 30,
  ),
  const PopupMenuDivider(),
  const PopupMenuItem<ContextItem>(
    value: ContextItem.help,
    child: Text('Help'),
    height: 30,
  ),
  const PopupMenuItem<ContextItem>(
    value: ContextItem.aboult,
    child: Text('About'),
    height: 30,
  ),
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
    if (imgsCurDir.isNotEmpty) {
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

  void onRightClick(Offset pos) async {
    ContextItem selection = await showMenu(
        color: Colors.grey[900],
        context: context,
        position: RelativeRect.fromLTRB(pos.dx, pos.dy, pos.dx, pos.dy),
        items: contextItens);

    switch (selection) {
      case ContextItem.openFile:
        FileChooserResult result = await showOpenPanel(allowedFileTypes: [
          FileTypeFilterGroup(label: 'Image', fileExtensions: suported_formats),
          FileTypeFilterGroup(label: 'All files'),
        ]);
        if (!result.canceled && result.paths.isNotEmpty) {
          iniFile(result.paths[0]);
          resetAllTransf();
        }
        break;
      case ContextItem.fileInfo:
        showDialog(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            title: Column(
              children: [
                Text(
                  'File Info',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Divider(),
              ],
            ),
            contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      'Name:',
                      'Directory:',
                      'Type:',
                      'Size:',
                      'Modified:',
                    ]
                        .map((e) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(e),
                            ))
                        .toList(),
                  ),
                  Divider(indent: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getFileNameFrom(curFile.path),
                        curFile.absolute.path.substring(
                            0, curFile.absolute.path.lastIndexOf('\\')),
                        curFile.path
                            .substring(curFile.path.lastIndexOf('.') + 1),
                        fileSizeHumanReadable(curFile.lengthSync()),
                        curFile.lastModifiedSync().toString(),
                      ]
                          .map((e) => SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(e),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        break;
      case ContextItem.help:
        break;
      case ContextItem.aboult:
        break;
      default:
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
        onSecondaryTapUp: (TapUpDetails details) =>
            onRightClick(details.localPosition),
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
