import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Provides a live view of the front camera
class CameraWidget extends StatelessWidget {
  bool _isCameraReady(CameraState cameraState) {
    return cameraState.cameraController != null && cameraState.cameraController.value.isInitialized;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraReady(Redux.store.state.cameraState)) {
      Redux.store.dispatch(CameraNotLoadedErrorAction());
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double widgetSize = screenWidth - constants.pad * 2.0;

    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        if (gameState == GameState.cameraNotLoadedError) {
          return Container(
            width: widgetSize,
            height: widgetSize,
            color: constants.grey,
          );
        } else if (gameState != GameState.takingPhoto) {
          return Container();
        }

        CameraState cameraState = Redux.store.state.cameraState;
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
                width: widgetSize,
                height: widgetSize,
                color: constants.grey,
              );
      },
    );
  }
}
