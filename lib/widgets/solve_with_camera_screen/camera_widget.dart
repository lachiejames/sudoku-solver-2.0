import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';

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
        return Stack(
          children: <Widget>[
            CameraPreview(cameraState.cameraController),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: MyValues.verticalPadding, color: MyColors.pink),
                  bottom: BorderSide(width: MyValues.verticalPadding, color: MyColors.pink),
                  left: BorderSide(width: MyValues.horizontalPadding, color: MyColors.pink),
                  right: BorderSide(width: MyValues.horizontalPadding, color: MyColors.pink),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
