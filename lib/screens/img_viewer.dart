import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../components/context_menu.dart';
import '../components/control_dock.dart';
import '../components/resetable_interactive_viewer.dart';
import '../constants.dart';
import '../providers/file_provider.dart';
import '../providers/settings_provider.dart';
import '../utils.dart';
import 'file_info_dialog.dart';
import 'open_file_dialog.dart';

/// This is the stateful widget that the main application instantiates.
class ImgViewer extends StatefulWidget {
  ImgViewer({Key key, this.filepath}) : super(key: key);

  final String filepath;

  @override
  _ImgViewerState createState() => _ImgViewerState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// AnimationControllers can be created with `vsync: this` because
/// of TickerProviderStateMixin.
class _ImgViewerState extends State<ImgViewer> with TickerProviderStateMixin {
  AnimationController _rotationController;

  Map<LogicalKeySet, Intent> _shortcuts;

  void _animateRotateLeft() {
    if (!_rotationController.isAnimating) {
      if (_rotationController.value == 0) {
        _rotationController.value = 1;
      }
      _rotationController.animateTo(_rotationController.value - 0.25);
    }
  }

  void _animateRotateRight() {
    if (!_rotationController.isAnimating) {
      if (_rotationController.value == 1) {
        _rotationController.value = 0;
      }
      _rotationController.animateTo(_rotationController.value + 0.25);
    }
  }

  void _animateResetRotation() {
    if (_rotationController.value < 0.5) {
      _rotationController.animateTo(0.0, duration: Duration(milliseconds: 200));
    } else {
      _rotationController.animateTo(1.0);
    }
  }

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // To execute after fist frame (The App parent is builded after this widget)
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        iniFile(widget.filepath);
      },
    );
    // Setup the shortcuts
    _shortcuts = {
      LogicalKeySet(LogicalKeyboardKey.arrowLeft): CallbackIntent(
        callback: goPreviousImg,
      ),
      LogicalKeySet(LogicalKeyboardKey.arrowRight): CallbackIntent(
        callback: goNextImg,
      ),
      LogicalKeySet(LogicalKeyboardKey.arrowUp): CallbackIntent(
        callback: _animateRotateLeft,
      ),
      LogicalKeySet(LogicalKeyboardKey.arrowDown): CallbackIntent(
        callback: _animateRotateRight,
      ),
      LogicalKeySet(
        LogicalKeyboardKey.controlLeft,
        LogicalKeyboardKey.keyO,
      ): CallbackIntent(callback: () {
        showOpenFileDialog(context).then(iniFile);
      }),
      LogicalKeySet(
        LogicalKeyboardKey.controlLeft,
        LogicalKeyboardKey.keyI,
      ): CallbackIntent(
        callback: () {
          var curFile = context.read<FileProvider>().curFile;

          if (curFile != null) {
            showFileInfoDialog(context);
          }
        },
      ),
      // TODO: LogicalKeyboardKey.contextMenu are not working
      // it is necessary to test with other keyboards
      LogicalKeySet(LogicalKeyboardKey(0x1070000005d)): CallbackIntent(
        callback: () {
          showContextMenu(
            context: context,
            pos: Offset(0, 0),
            curFile: context.read<FileProvider>().curFile,
            onSelectFile: iniFile,
          );
        },
      ),
    };
  }

  void iniFile(String filePath) {
    if (filePath != null) {
      context.read<FileProvider>().setInitialFile(filePath, suportedFormats);
      updateTitle();
    }
    resetRotation();
  }

  void resetRotation() {
    _rotationController.reset();
  }

  void updateTitle() {
    var curFile = context.read<FileProvider>().curFile;

    appWindow.title = 'ImgViewer - ${curFile.path}';
  }

  void goNextImg() {
    if (context.read<FileProvider>().goNextFile()) {
      resetRotation();
      updateTitle();
    }
  }

  void goPreviousImg() {
    if (context.read<FileProvider>().goPreviousFile()) {
      resetRotation();
      updateTitle();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var curFile = context.watch<FileProvider>().curFile;
    var settings = context.watch<SettingsProvider>().settings;
    return Shortcuts(
      shortcuts: _shortcuts,
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: ResetableInteractiveViewer(
            // Forces the widget to be rebuilt when the file is changed
            // to reset animations (The InteractiveViewer offers no
            // way to stop animations)
            key: ValueKey(curFile),
            onRightClick: (Offset pos) {
              showContextMenu(
                context: context,
                pos: pos,
                curFile: curFile,
                onSelectFile: iniFile,
              );
            },
            onDoubleClick: _animateResetRotation,
            child: RotationTransition(
              turns: _rotationController,
              child: curFile != null
                  ? Image.file(
                      curFile,
                      scale: 1.0,
                      filterQuality: settings.filterQuality,
                      errorBuilder: (
                        BuildContext context,
                        Object exception,
                        StackTrace stackTrace,
                      ) {
                        print('Error loading image');
                        print(exception.toString());
                        return Text('The image could not be loaded. 😢');
                      },
                    )
                  : null,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: curFile != null
              ? Focus(
                  // Disable the navigation in the dock
                  autofocus: false,
                  descendantsAreFocusable: false,
                  child: ControlDock(
                    onPressRotLeft: _animateRotateLeft,
                    onPressRotRight: _animateRotateRight,
                    onPressPrev: goPreviousImg,
                    onPressNext: goNextImg,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
