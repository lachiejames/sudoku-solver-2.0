import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

class CameraState {
  int croppedImageWidth;

  Future<File> getImageFileFromAssets(String path) async {
    ByteData byteData;
    try {
      byteData = await rootBundle.load('assets/$path');
    } catch (e) {
      print('ERROR: no file found at assets/$path');
      print(e);
      return null;
    }
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<File> takePicture(CameraController cameraController) async {
    File _pickedImageFile;

    final String imagePath = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
    print(await getTemporaryDirectory());
    try {
      await cameraController.takePicture(imagePath);
      _pickedImageFile = File(imagePath);
      assert(_pickedImageFile != null);
    } catch (e) {
      print('ERROR: could not create file at $imagePath');
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
    this.croppedImageWidth = (imageWidth * MyValues.cameraWidth / MyValues.screenWidth).round();
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

    final String croppedImagePath = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
    File _croppedImageFile;
    try {
      _croppedImageFile = await File(croppedImagePath).create();
      _croppedImageFile.writeAsBytesSync(encodePng(croppedImage));
    } catch (e) {
      print('ERROR: cropped image file could not be created at $croppedImagePath');
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

    Redux.store.dispatch(PhotoProcessedAction(sudoku));
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
    Sudoku sudoku = Sudoku(tileStateMap: TileState.initTileStateMap());
    double factor = this.croppedImageWidth / 9;
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

  CameraState copyWith() {
    return CameraState();
  }
}
