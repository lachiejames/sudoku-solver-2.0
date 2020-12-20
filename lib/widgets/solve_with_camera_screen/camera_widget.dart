import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;

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
        double widgetSize = cameraState.screenSize.width - my_values.pad * 2.0;

        return (cameraState.cameraController != null &&
                cameraState.cameraController.value.isInitialized)
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
                        height: widgetSize /
                            cameraState.cameraController.value.aspectRatio,
                        child: CameraPreview(cameraState
                            .cameraController), // this is my CameraPreview
                      ),
                    ),
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
