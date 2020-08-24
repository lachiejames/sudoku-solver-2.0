import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/services.dart';
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
  int croppedImageWidth;

  CameraState({
    @required this.cameraDescription,
    @required this.cameraController,
  });

  Future<File> _getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<File> takePicture() async {
    File _pickedImageFile;
    if (MyValues.runningIntegrationTests) {
      _pickedImageFile = await _getImageFileFromAssets('mock_sudoku.jpg');
      return _pickedImageFile;
    } else {
      try {
        // Filename must be unique, or else an error is thrown
        final String imagePath = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
        await this.cameraController.takePicture(imagePath);
        _pickedImageFile = File(imagePath);
      } catch (e) {
        print(e);
      }
    }
    assert(_pickedImageFile != null);

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
    File _croppedImageFile = await File(croppedImagePath).create();
    _croppedImageFile.writeAsBytesSync(encodePng(croppedImage));
    return _croppedImageFile;
  }

  Future<Sudoku> getSudokuFromImage(File pickedImageFile) async {
    File _croppedImageFile = await cropPictureToSudokuSize(pickedImageFile);

    final FirebaseVisionImage _firebaseVisionImage = FirebaseVisionImage.fromFile(_croppedImageFile);
    final TextRecognizer _textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText _visionText = await _textRecognizer.processImage(_firebaseVisionImage);

    final List<TextElement> textElements = getTextElementsFromVisionText(_visionText);
    final Sudoku sudoku = constructSudokuFromTextElements(textElements);
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

  CameraState copyWith({
    CameraDescription cameraDescription,
    CameraController cameraController,
  }) {
    return CameraState(
      cameraDescription: cameraDescription ?? this.cameraDescription,
      cameraController: cameraController ?? this.cameraController,
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
