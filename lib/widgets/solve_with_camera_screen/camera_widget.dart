import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CameraState>(
      distinct: true,
      converter: (store) => store.state.cameraState,
      builder: (context, cameraState) {
        final size = MediaQuery.of(context).size;
        final deviceRatio = size.width / size.height;

        return (cameraState.cameraController != null && cameraState.cameraController.value.isInitialized)
            ? Transform.scale(
                scale: cameraState.cameraController.value.aspectRatio / deviceRatio,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: cameraState.cameraController.value.aspectRatio,
                    child: CameraPreview(cameraState.cameraController),
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
