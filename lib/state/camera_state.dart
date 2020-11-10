import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
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

  List<TextElement> getTextElementsFromVisionText(VisionText visionText) {
    final List<TextElement> textElements = [];
    for (TextBlock textBlock in visionText.blocks) {
      for (TextLine textLine in textBlock.lines) {
        for (TextElement textElement in textLine.elements) {
          print(textElement.text);
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

  Rect makeRect(int row, int col, double factor) {
    return Rect.fromLTRB(
      col * factor,
      row * factor,
      (col + 1) * factor,
      (row + 1) * factor,
    );
  }

  TileState mostLikelyTileForTextElement(TextElement textElement, Sudoku sudoku) {
    TileState mostLikelyTile;
    double greatestArea = 0.0;
    double factor = 900; //this.croppedImageWidth / 9;

    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        double overlappingArea = this.calculateOverlapArea(
          textElement.boundingBox,
          this.makeRect(row, col, factor),
        );
        if (greatestArea < overlappingArea) {
          greatestArea = overlappingArea;
          mostLikelyTile = sudoku.getTileStateAt(row + 1, col + 1);
          // print('row=${row + 1}, col=${col + 1}, value=${textElement.text}, greatestArea=$greatestArea');
        } else {
          // print('NOPE: row=${row + 1}, col=${col + 1}, value=${textElement.text}, overlappingArea=$overlappingArea');
        }
      }
    }
    return mostLikelyTile;
  }

  Sudoku constructSudokuFromTextElements(List<TextElement> textElements) {
    Sudoku sudoku = Sudoku(tileStateMap: TileState.initTileStateMap());
    for (TextElement textElement in textElements) {
      sudoku.addValueToTile(int.parse(textElement.text), this.mostLikelyTileForTextElement(textElement, sudoku));
      if (int.parse(textElement.text) == 7) {
        print(7);
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

  static const _fullCircleDegrees = 360;

  Future<VisionText> processCameraImage(CameraImage image, int sensorOrientation,
      NativeDeviceOrientation deviceOrientation, TextRecognizer textRecognizer) {
    // print(jsonEncode(image));

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

    final complexOrientation = (sensorOrientation + deviceOrientationCompensation) % _fullCircleDegrees;
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

  Future<void> getSudokuFromCamera() async {
    print('getSudokuFromCamera() - now using CameraImage');

    CameraImage cameraImage = await this.takePicture();
    assert(cameraImage != null);
    final TextRecognizer _textRecognizer = FirebaseVision.instance.textRecognizer();
    final NativeDeviceOrientationCommunicator _deviceOrientationProvider = NativeDeviceOrientationCommunicator();
    print('processing the image');
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
