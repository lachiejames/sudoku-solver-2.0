import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';

class CameraState {
  final CameraDescription cameraDescription;
  final CameraController cameraController;

  File pickedImageFile;

  CameraState({
    @required this.cameraDescription,
    @required this.cameraController,
  }) {
    assert(this.cameraDescription != null);
    assert(this.cameraController != null);
  }

  Future<void> takePicture() async {
    try {
      // Filename must be unique, or else an error is thrown
      final String imagePath = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
      await this.cameraController.takePicture(imagePath);
      this.pickedImageFile = File(imagePath);
      assert(this.pickedImageFile != null);
    } catch (e) {
      print(e);
    }

    cropPictureToSudokuSize();
  }

  Future<File> cropPictureToSudokuSize() async {
    Image pickedImage = decodeImage(pickedImageFile.readAsBytesSync());
    pickedImage = copyRotate(pickedImage, 90);
    Image croppedImage = copyCrop(pickedImage, 0, 0, 200, 200);

    final String croppedImagePath = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
    File croppedImageFile = await File(croppedImagePath).create();
    croppedImageFile.writeAsBytesSync(encodePng(croppedImage));
    return croppedImageFile;
  }

  Future<Sudoku> getSudokuFromImage() async {
        // final FirebaseVisionImage firebaseVisionImage = FirebaseVisionImage.fromFile(pickedImageFile);
    // textRecognizer = FirebaseVision.instance.textRecognizer();
    // visionText = await textRecognizer.processImage(firebaseVisionImage);

  }

  CameraState copyWith({
    CameraDescription cameraDescription,
    CameraController cameraController,
  }) {
    return CameraState(
      cameraDescription: cameraDescription ?? this.cameraDescription,
      cameraController: cameraController ?? this.cameraController,
    );
  }
}
