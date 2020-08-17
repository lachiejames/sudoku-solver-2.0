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
        return FutureBuilder<void>(
          future: cameraState.initCamera(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print('\n\n\n Connection done \n\n\n');
              return Container(
                height: 300,
                width: 300,
                child: CameraPreview(cameraState.cameraController),
              );
            } else if (snapshot.hasError) {
              print('\n\n\n Connection ERROR \n\n\n');
              return Text('Could not load camera :(');
            } else {
              print('\n\n\n Connection waiting \n\n\n');
              return Container(
                  child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text('Camera will appear here'),
                ],
              ));
            }
          },
        );
      },
    );
  }
}
