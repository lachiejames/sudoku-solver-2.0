import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

CameraImage cameraImage;

/// All state relating to the Camera
class CameraState {
  int croppedImageWidth;
  final CameraController cameraController;

  CameraState({this.cameraController});

  Future<CameraImage> takePicture() async {
    return cameraImage;
  }

  bool isInSudokuBounds(TextElement textElement) {
    return this.calculateOverlapArea(my_values.photoRect, textElement.boundingBox) > 0.0;
  }

  bool isSudokuElement(TextElement textElement) {
    return (this.isNumeric(textElement.text) &&
        textElement.text.length == 1 &&
        this.isInSudokuBounds(textElement) &&
        1 <= int.parse(textElement.text) &&
        int.parse(textElement.text) <= 9);
  }

  List<TextElement> getTextElementsFromVisionText(VisionText visionText) {
    final List<TextElement> textElements = [];
    for (TextBlock textBlock in visionText.blocks) {
      for (TextLine textLine in textBlock.lines) {
        for (TextElement textElement in textLine.elements) {
          if (this.isSudokuElement(textElement)) {
            print('value=${textElement.text}, boundingBox=${textElement.boundingBox}');
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

  Rect makeTileRect(int row, int col) {
    double horizontalFactor = (my_values.photoRect.right - my_values.photoRect.left) / 9.0;
    double verticalFactor = (my_values.photoRect.bottom - my_values.photoRect.top) / 9.0;
    assert(horizontalFactor > 0);
    assert(verticalFactor > 0);

    return Rect.fromLTRB(
      my_values.photoRect.left + (col - 1) * horizontalFactor,
      my_values.photoRect.top + (row - 1) * verticalFactor,
      my_values.photoRect.left + col * horizontalFactor,
      my_values.photoRect.top + row * verticalFactor,
    );
  }

  TileState mostLikelyTileForTextElement(Rect textElementBoundingBox, Sudoku sudoku) {
    TileState mostLikelyTile;
    double greatestArea = 0.0;

    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        Rect tileRect = this.makeTileRect(row, col);
        assert(tileRect.left > 0);
        assert(tileRect.top > 0);
        assert(tileRect.right > 0);
        assert(tileRect.bottom > 0);
        double overlappingArea = this.calculateOverlapArea(
          textElementBoundingBox,
          tileRect,
        );
        if (greatestArea < overlappingArea) {
          greatestArea = overlappingArea;
          mostLikelyTile = sudoku.getTileStateAt(row, col);
        }
      }
    }
    assert(mostLikelyTile != null);
    return mostLikelyTile;
  }

  Sudoku constructSudokuFromTextElements(List<TextElement> textElements) {
    Sudoku sudoku = Sudoku(tileStateMap: TileState.initTileStateMap());
    for (TextElement textElement in textElements) {
      sudoku.addValueToTile(
        int.parse(textElement.text),
        this.mostLikelyTileForTextElement(textElement.boundingBox, sudoku),
      );
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

  Future<VisionText> processCameraImage(CameraImage image, int sensorOrientation,
      NativeDeviceOrientation deviceOrientation, TextRecognizer textRecognizer) {
    assert(image != null);
    final bytes = _concatenatePlanes(image.planes);
    final metadata = _prepareMetadata(image, sensorOrientation, deviceOrientation);
    final visionImage = FirebaseVisionImage.fromBytes(bytes, metadata);
    return textRecognizer.processImage(visionImage);
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  FirebaseVisionImageMetadata _prepareMetadata(
      CameraImage image, int sensorOrientation, NativeDeviceOrientation deviceOrientation) {
    return FirebaseVisionImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rawFormat: image.format.raw,
      planeData: image.planes
          .map((currentPlane) => FirebaseVisionImagePlaneMetadata(
              bytesPerRow: currentPlane.bytesPerRow, height: currentPlane.height, width: currentPlane.width))
          .toList(),
      rotation: _pickImageRotation(sensorOrientation, deviceOrientation),
    );
  }

  ImageRotation _pickImageRotation(int sensorOrientation, NativeDeviceOrientation deviceOrientation) {
    int deviceOrientationCompensation = 0;
    switch (deviceOrientation) {
      case NativeDeviceOrientation.landscapeLeft:
        deviceOrientationCompensation = -90;
        break;
      case NativeDeviceOrientation.landscapeRight:
        deviceOrientationCompensation = 90;
        break;
      case NativeDeviceOrientation.portraitDown:
        deviceOrientationCompensation = 180;
        break;
      default:
        deviceOrientationCompensation = 0;
        break;
    }

    final complexOrientation = (sensorOrientation + deviceOrientationCompensation) % 360;
    switch (complexOrientation) {
      case 0:
        return ImageRotation.rotation0;
      case 90:
        return ImageRotation.rotation90;
      case 180:
        return ImageRotation.rotation180;
      case 270:
        return ImageRotation.rotation270;
      default:
        throw Exception("CameraToTextRecognizerBridge: Rotation must be 0, 90, 180, or 270.");
    }
  }

  void setPhotoSizeProperties() {
    my_values.photoSize = Size(cameraImage.width * 1.0, cameraImage.height * 1.0);
    double cameraHoriFactor = my_values.photoSize.width / my_values.cameraWidgetSize.width;
    double cameraVertFactor = my_values.photoSize.height / my_values.cameraWidgetSize.height;
    my_values.photoRect = Rect.fromLTRB(
      cameraHoriFactor * my_values.cameraWidgetRect.left,
      cameraVertFactor * my_values.cameraWidgetRect.top,
      cameraHoriFactor * my_values.cameraWidgetRect.right,
      cameraVertFactor * my_values.cameraWidgetRect.bottom,
    );
    assert(my_values.photoRect.left > 0);
    assert(my_values.photoRect.top > 0);
    assert(my_values.photoRect.right > 0);
    assert(my_values.photoRect.bottom > 0);
  }

  Future<void> getSudokuFromCamera() async {
    CameraImage cameraImage = await this.takePicture();
    assert(cameraImage != null);
    this.setPhotoSizeProperties();

    final TextRecognizer _textRecognizer = FirebaseVision.instance.textRecognizer();
    final NativeDeviceOrientationCommunicator _deviceOrientationProvider = NativeDeviceOrientationCommunicator();
    final VisionText _visionText = await this.processCameraImage(
      cameraImage,
      this.cameraController.description.sensorOrientation,
      await _deviceOrientationProvider.orientation(useSensor: true),
      _textRecognizer,
    );

    await _textRecognizer.close();

    final List<TextElement> textElements = this.getTextElementsFromVisionText(_visionText);
    final Sudoku sudoku = this.constructSudokuFromTextElements(textElements);
    print(sudoku);
    Redux.store.dispatch(PhotoProcessedAction(sudoku));
  }
}
