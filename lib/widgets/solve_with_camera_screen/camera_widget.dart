import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';

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
        return Stack(
          children: <Widget>[
            (cameraState.cameraController != null) ? CameraPreview(cameraState.cameraController) : CircularProgressIndicator(),
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
