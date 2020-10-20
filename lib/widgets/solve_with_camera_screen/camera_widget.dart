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
    print('_initCamera');
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
    print('build');
    return FutureBuilder<void>(
      future: _initCameraReference,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            print('builder');

        if (snapshot.connectionState == ConnectionState.done) {
          assert(_cameraController.value.isInitialized);
          my_values.cameraController = _cameraController;
          // Camera takes up the whole screen
              print('container');

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
          return Container();
        }
      },
    );
  }



//    CameraController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(cameras[0], ResolutionPreset.medium);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return AspectRatio(
//         aspectRatio:
//         controller.value.aspectRatio,
//         child: CameraPreview(controller));
//   }
}
