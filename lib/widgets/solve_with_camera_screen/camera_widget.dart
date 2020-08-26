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
  CameraDescription _cameraDescription;
  CameraController _cameraController;

  Future<void> _initCamera() async {
    print('_initCamera');
    try {
      _cameraDescription = (await availableCameras())[0];
    } catch (e) {
      print(e);
    }
    print('_cameraController');

    _cameraController = CameraController(_cameraDescription, ResolutionPreset.max);

    try {
      await _cameraController.initialize();
    } catch (e) {
      print(e);
    }
    print('initialize');
  }

  Widget makeCameraPreview(BuildContext context) {
    return FutureBuilder<void>(
      future: _initCamera(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CameraPreview(_cameraController),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('snapshot.hasError'));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CameraState>(
      distinct: true,
      converter: (store) => store.state.cameraState,
      builder: (context, cameraState) {
        return Stack(
          children: <Widget>[
            makeCameraPreview(context),
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
