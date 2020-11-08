import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
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
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

/// All state relating to the Camera
class CameraState {
  int croppedImageWidth;
  final CameraController cameraController;

  CameraState({this.cameraController});

  Future<File> getImageFileFromAssets(String path) async {
    ByteData byteData;
    try {
      byteData = await rootBundle.load('assets/$path');
    } on Exception catch (e) {
      print('ERROR: no file found at assets/$path\n$e');
      return null;
    }
    File file = await File('${(await getApplicationDocumentsDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<File> takePicture() async {
    File _pickedImageFile;

    final String imagePath = join((await getApplicationDocumentsDirectory()).path,
        '_pickedImageFile${DateTime.now().millisecondsSinceEpoch}.png');

    try {
      if (await File(imagePath).exists()) {
        await File(imagePath).delete();
      }
      await this.cameraController.takePicture(imagePath);
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
    int verticalStartPixel = ((imageHeight - croppedImageHeight) / 2).round() + my_values.appBarHeight;

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

  Future<void> getSudokuFromCamera() async {
    File pickedImageFile = await this.takePicture();
    assert(pickedImageFile != null);
    File croppedImageFile = await this.cropPictureToSudokuSize(pickedImageFile);
    final FirebaseVisionImage _firebaseVisionImage = FirebaseVisionImage.fromFile(croppedImageFile);
    final TextRecognizer _textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText _visionText = await _textRecognizer.processImage(_firebaseVisionImage);
    final List<TextElement> textElements = this.getTextElementsFromVisionText(_visionText);
    final Sudoku sudoku = this.constructSudokuFromTextElements(textElements);
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

  double calculateOverlapArea(Rect rect1, Rect rect2) {
    double xOverlap = max(0, min(rect1.right, rect2.right) - max(rect1.left, rect2.left));
    double yOverlap = max(0, min(rect1.bottom, rect2.bottom) - max(rect1.top, rect2.top));
    return xOverlap * yOverlap;
  }

  // TileState mostLikelyTileForNumber() {
  //   HashMap<TileState, double> tileAreas = HashMap<TileState, double>();
  //   TileState mostLikelyTile;
  //   double greatestArea = 0.0;

  //   for (int row = 0; row < 9; row++) {
  //     for (int col = 0; col < 9; col++) {
  //       double overlappingArea = this.calculateOverlapArea(rect1, rect2)
  //       tileAreas[Redux.store.state.tileStateMap[TileKey(row: row, col: col)]];
  //     }
  //   }
  // }

  Sudoku constructSudokuFromTextElements(List<TextElement> textElements) {
    Sudoku sudoku = Sudoku(tileStateMap: TileState.initTileStateMap());
    double factor = this.croppedImageWidth / 9;
    for (TextElement textElement in textElements) {
      print('value=${textElement.text}, boundingBox=${textElement.boundingBox}');
      if (textElement.text.length == 1 && this.isNumeric(textElement.text)) {
        TileState mostLikelyTile;
        double greatestArea = 0.0;

        for (int row = 0; row < 9; row++) {
          for (int col = 0; col < 9; col++) {
            double overlappingArea = this.calculateOverlapArea(
              textElement.boundingBox,
              Rect.fromLTRB(
                col * factor,
                row * factor,
                (col + 1) * factor,
                (row + 1) * factor,
              ),
            );
            if (greatestArea < overlappingArea) {
              greatestArea = overlappingArea;
              mostLikelyTile = sudoku.getTileStateAt(row + 1, col + 1);
            }
          }
        }
        // print('adding ${int.parse(textElement.text)} to $mostLikelyTile');
        sudoku.addValueToTile(int.parse(textElement.text), mostLikelyTile);
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

  CameraState copyWith({CameraController cameraController}) {
    return CameraState(cameraController: cameraController);
  }

  static CameraState initCameraState() {
    return CameraState(
      cameraController: null,
    );
  }
}
