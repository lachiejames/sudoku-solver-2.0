import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

/// All state relating to the Camera
class CameraState {
  int croppedImageWidth;

  Future<File> getImageFileFromAssets(String path) async {
    ByteData byteData;
    try {
      byteData = await rootBundle.load('assets/$path');
    } on Exception catch (e) {
      print('ERROR: no file found at assets/$path');
      print(e);
      return null;
    }
    File file = await File('${(await getApplicationDocumentsDirectory()).path}/$path');
    await file
        .writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<File> takePicture(CameraController cameraController) async {
    File _pickedImageFile;

    final String imagePath = join((await getApplicationDocumentsDirectory()).path,
        '_pickedImageFile${DateTime.now().millisecondsSinceEpoch}.png');

    try {
      await cameraController.takePicture(imagePath);
      _pickedImageFile = File(imagePath);
      assert(_pickedImageFile != null);
    } on Exception catch (e) {
      print(e);
    }

    return _pickedImageFile;
  }

  Future<File> cropPictureToSudokuSize(File pickedImageFile) async {
    Image pickedImage = decodeImage(pickedImageFile.readAsBytesSync());

    if (pickedImage.height < pickedImage.width) {
      pickedImage = copyRotate(pickedImage, 90);
    }

    int imageWidth = pickedImage.width;
    int imageHeight = pickedImage.height;
    this.croppedImageWidth = (imageWidth * my_values.cameraWidth / my_values.screenWidth).round();
    int croppedImageHeight = this.croppedImageWidth;
    int horizontalStartPixel = ((imageWidth - this.croppedImageWidth) / 2).round();
    int verticalStartPixel = ((imageHeight - croppedImageHeight) / 2).round();

    Image croppedImage = copyCrop(
      pickedImage,
      horizontalStartPixel,
      verticalStartPixel,
      this.croppedImageWidth,
      croppedImageHeight,
    );

    final String croppedImagePath = join((await getApplicationDocumentsDirectory()).path,
        '_croppedImageFile${DateTime.now().millisecondsSinceEpoch}.png');
    File _croppedImageFile;
    try {
      _croppedImageFile = await File(croppedImagePath).create();
      assert(_croppedImageFile != null);
      _croppedImageFile.writeAsBytesSync(encodePng(croppedImage));
    } on Exception catch (e) {
      print(e);
    }
    return _croppedImageFile;
  }

  Future<void> getSudokuFromCamera(CameraController cameraController) async {
    File pickedImageFile = await takePicture(cameraController);
    File croppedImageFile = await cropPictureToSudokuSize(pickedImageFile);

    final FirebaseVisionImage _firebaseVisionImage = FirebaseVisionImage.fromFile(croppedImageFile);
    final TextRecognizer _textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText _visionText = await _textRecognizer.processImage(_firebaseVisionImage);

    final List<TextElement> textElements = getTextElementsFromVisionText(_visionText);
    final Sudoku sudoku = constructSudokuFromTextElements(textElements);

    print('photo processed');
    Redux.store.dispatch(PhotoProcessedAction(sudoku));
  }

  List<TextElement> getTextElementsFromVisionText(VisionText visionText) {
    final List<TextElement> textElements = [];
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
    Sudoku sudoku = Sudoku(tileStateMap: TileState.initTileStateMap());
    double factor = this.croppedImageWidth / 9;
    for (TextElement textElement in textElements) {
      double tileImgX = textElement.boundingBox.center.dx;
      double tileImgY = textElement.boundingBox.center.dy;
      int value = int.parse(textElement.text);
      for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
          if ((row * factor < tileImgY && tileImgY < (row + 1) * factor) &&
              (col * factor < tileImgX && tileImgX < (col + 1) * factor)) {
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

  CameraState copyWith() {
    return CameraState();
  }
}
