import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;

/// Provides a live view of the front camera
class CameraWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double widgetSize = screenWidth - my_values.pad * 2.0;
    return StoreConnector<AppState, CameraState>(
      distinct: true,
      converter: (store) => store.state.cameraState,
      builder: (context, cameraState) {
        return (cameraState.cameraController != null && cameraState.cameraController.value.isInitialized)
            ? Container(
                width: widgetSize,
                height: widgetSize,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        width: widgetSize,
                        height: widgetSize / cameraState.cameraController.value.aspectRatio,
                        child: CameraPreview(cameraState.cameraController),
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                height: widgetSize,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
