import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:sudoku_solver_2/algorithm/photo_processor.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';

/// All state relating to the Camera
class CameraState {
  final CameraController cameraController;
  final Size screenSize;

  CameraState({this.cameraController, this.screenSize});

  Future<File> getImageFileFromCamera() async {
    final String imagePath = await getUniqueFilePath();

    try {
      await cameraController.takePicture(imagePath);
    } on Exception catch (e) {
      await logError('ERROR: failed to take picture', e);
      Redux.store.dispatch(PhotoProcessingErrorAction());
    }

    final File imageFile = await File(imagePath).create();

    return imageFile;
  }

  CameraState copyWith({CameraController cameraController, Size screenSize, Rect cameraWidgetBounds}) => CameraState(
        cameraController: cameraController ?? this.cameraController,
        screenSize: screenSize ?? this.screenSize,
      );
}
