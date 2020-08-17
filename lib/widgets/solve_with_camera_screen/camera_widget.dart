import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';

class CameraWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CameraState>(
      distinct: true,
      converter: (store) => store.state.cameraState,
      builder: (context, cameraState) {
        return Container(
          height: 300,
          width: 300,
          child: CameraPreview(cameraState.cameraController),
        );
      },
    );
  }
}
