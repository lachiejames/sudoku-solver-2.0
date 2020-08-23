import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

class CameraState {
  final CameraDescription cameraDescription;
  final CameraController cameraController;

  File pickedImageFile;
  File croppedImageFile;

  CameraState({
    @required this.cameraDescription,
    @required this.cameraController,
    this.pickedImageFile,
  });

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
    int imageWidth = pickedImage.width;
    int imageHeight = pickedImage.height;
    print('imageWidth=$imageWidth');
    print('imageHeight=$imageHeight');
    int croppedImageWidth = (imageWidth * MyValues.cameraWidth / MyValues.screenWidth).round();
    int croppedImageHeight = croppedImageWidth;
    print('croppedImageWidth=$croppedImageWidth');
    print('croppedImageHeight=$croppedImageHeight');
    int x = ((imageWidth - croppedImageWidth) / 2).round();
    int y = ((imageHeight - croppedImageHeight) / 2).round();

    print('x=$x');
    print('y=$y');

    Image croppedImage = copyCrop(pickedImage, x, y, croppedImageWidth, croppedImageHeight);
    print('croppedImageWidth=${croppedImage.width}');
    print('croppedImageHeight=${croppedImage.height}');

    final String croppedImagePath = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
    File _croppedImageFile = await File(croppedImagePath).create();
    _croppedImageFile.writeAsBytesSync(encodePng(croppedImage));
    this.croppedImageFile = _croppedImageFile;
    return _croppedImageFile;
  }

  Future<Sudoku> getSudokuFromImage() async {
    takePicture();
    File _croppedImageFile = await cropPictureToSudokuSize();

    final FirebaseVisionImage _firebaseVisionImage = FirebaseVisionImage.fromFile(_croppedImageFile);
    final TextRecognizer _textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText _visionText = await _textRecognizer.processImage(_firebaseVisionImage);

    final List<TextElement> textElements = getTextElementsFromVisionText(_visionText);
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
            print(textElement);
          }
        }
      }
    }
    return textElements;
  }

  Sudoku constructSudokuFromTextElements(List<TextElement> textElements) {
    Sudoku sudoku = Sudoku(tileStateMap: TileState.initTileStateMap());
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
    File pickedImageFile,
  }) {
    return CameraState(
      cameraDescription: cameraDescription ?? this.cameraDescription,
      cameraController: cameraController ?? this.cameraController,
      pickedImageFile: pickedImageFile ?? this.pickedImageFile,
    );
  }

  static Future<CameraState> initCamera() async {
    CameraDescription cameraDescription;
    CameraController cameraController;
    try {
      cameraDescription = (await availableCameras())[0];
      cameraController = CameraController(cameraDescription, ResolutionPreset.max);
      await cameraController.initialize();
    } catch (e) {
      print(e);
    }

    return CameraState(
      cameraDescription: cameraDescription,
      cameraController: cameraController,
    );
  }
}
