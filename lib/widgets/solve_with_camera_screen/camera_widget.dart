import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;

/// Provides a live view of the front camera
class CameraWidget extends StatefulWidget {
  CameraWidget({Key key}) : super(key: key);

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraDescription _cameraDescription;
  CameraController _cameraController;
  Future<void> _initCameraReference;

  @override
  void initState() {
    super.initState();
    _initCameraReference = _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameraDescription = (await availableCameras())[0];
    } on Exception catch (e) {
      print(e);
    }

    _cameraController = CameraController(_cameraDescription, ResolutionPreset.max);

    try {
      await _cameraController.initialize();
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initCameraReference,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        my_values.cameraController = _cameraController;
        if (snapshot.connectionState == ConnectionState.done) {
          // Camera takes up the whole screen
          return Container(
            height: my_values.screenHeight,
            width: my_values.screenWidth,
            child: CameraPreview(_cameraController),
          );
        } else if (snapshot.hasError) {
          // Dispatch CannotLoadCameraAction
          return Center(child: Text('snapshot.hasError'));
        } else {
          // Shown while loading
          return Container(
            
          );
        }
      },
    );
  }
}
