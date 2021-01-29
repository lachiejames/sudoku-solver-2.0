import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Provides a live view of the front camera
class CameraWidget extends StatelessWidget {
  bool _isCameraReady(CameraState cameraState) =>
      cameraState.cameraController != null && cameraState.cameraController.value.isInitialized;

  const CameraWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!_isCameraReady(Redux.store.state.cameraState)) {
      Redux.store.dispatch(CameraNotLoadedErrorAction());
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double widgetSize = screenWidth - pad * 2.0;

    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (Store<AppState> store) => store.state.gameState,
      builder: (BuildContext context, GameState gameState) {
        if (gameState == GameState.cameraNotLoadedError) {
          return Container(
            width: widgetSize,
            height: widgetSize,
            color: grey,
          );
        } else if (gameState != GameState.takingPhoto) {
          return Container();
        }

        final CameraState cameraState = Redux.store.state.cameraState;
        return (cameraState.cameraController != null && cameraState.cameraController.value.isInitialized)
            ? SizedBox(
                width: widgetSize,
                height: widgetSize,
                child: ClipRect(
                  child: OverflowBox(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: SizedBox(
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
                color: grey,
              );
      },
    );
  }
}
