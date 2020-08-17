import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';

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
    takePicture();
    cropPictureToSudokuSize();

    final FirebaseVisionImage firebaseVisionImage = FirebaseVisionImage.fromFile(pickedImageFile);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(firebaseVisionImage);

    final List<TextElement> textElements = getTextElementsFromVisionText(visionText);
    print(textElements);
    final Sudoku sudoku = constructSudokuFromTextElements(textElements);
    print(sudoku);
    return sudoku;
  }

  List<TextElement> getTextElementsFromVisionText(VisionText visionText) {
    final List<TextElement> textElements = List();
    for (TextBlock textBlock in visionText.blocks) {
      for (TextLine textLine in textBlock.lines) {
        for (TextElement textElement in textLine.elements) {
          if (this.isNumeric(textElement.text) && textElement.text.length == 1) {
            textElements.add(textElement);
          }
        }
      }
    }
    return textElements;
  }

  Sudoku constructSudokuFromTextElements(List<TextElement> textElements) {
    Sudoku sudoku = Sudoku(tileStateMap: MyWidgets.initTileStateMap());
    double factor = 200 / 9;
    for (TextElement textElement in textElements) {
      double tileImgX = textElement.boundingBox.center.dx;
      double tileImgY = textElement.boundingBox.center.dy;
      int value = int.parse(textElement.text);
      for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
          if ((row * factor < tileImgY && tileImgY < (row + 1) * factor) && (col * factor < tileImgX && tileImgX < (col + 1) * factor)) {
            sudoku.addValueToTile(value, sudoku.getTileStateAt(row + 1, col + 1));
          }
        }
      }
    }
    return sudoku;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
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
