import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';

/// Provides a live view of the front camera
class CameraWidget extends StatefulWidget {
  CameraWidget({Key key}) : super(key: key);

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  @override
  void initState() {
    super.initState();
    Redux.store.state.cameraState.cameraController.startImageStream((CameraImage image) {
      cameraImage = image;
    });
  }

  @override
  void dispose() {
    Redux.store.state.cameraState.cameraController.stopImageStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CameraState>(
      distinct: true,
      converter: (store) => store.state.cameraState,
      builder: (context, cameraState) {
        return (cameraState.cameraController != null && cameraState.cameraController.value.isInitialized)
            ? Container(
                height: my_values.screenSize.height - my_values.appBarHeight,
                width: my_values.screenSize.width,
                child: CameraPreview(cameraState.cameraController),
              )
            : Container();
      },
    );
  }
}
