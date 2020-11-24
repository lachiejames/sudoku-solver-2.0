import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
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
  final CameraController cameraController;

  CameraState({this.cameraController});

  Future<String> getUniqueFilePath() async {
    return join((await getApplicationDocumentsDirectory()).path, '${Random().nextDouble()}.png');
  }

  Future<File> getImageFileFromCamera() async {
    String imagePath = await getUniqueFilePath();

    try {
      await this.cameraController.takePicture(imagePath);
    } on Exception catch (e) {
      print(e);
    }

    return File(imagePath);
  }

  void setPhotoSizeProperties(Image fullImage) {
    my_values.fullPhotoSize = Size(fullImage.width.toDouble(), fullImage.height.toDouble());

    assert(my_values.cameraWidgetSize != null);
    double horizontalPhotoToWidgetRatio = my_values.fullPhotoSize.width / my_values.cameraWidgetSize.width;
    double verticalPhotoToWidgetRatio = my_values.fullPhotoSize.height / my_values.cameraWidgetSize.height;

    my_values.sudokuPhotoRect = Rect.fromLTRB(
      horizontalPhotoToWidgetRatio * my_values.cameraWidgetRect.left,
      verticalPhotoToWidgetRatio * my_values.cameraWidgetRect.top,
      horizontalPhotoToWidgetRatio * my_values.cameraWidgetRect.right,
      verticalPhotoToWidgetRatio * my_values.cameraWidgetRect.bottom,
    );

    my_values.sudokuPhotoSize = Size(
      fullImage.width.toDouble(),
      fullImage.height.toDouble(),
    );

    my_values.tilePhotoSize = Size(
      fullImage.width.toDouble(),
      fullImage.height.toDouble(),
    );
  }

  Future<Image> getImageFromFile(File file) async {
    return decodeImage(file.readAsBytesSync());
  }

  Future<File> getFileFromImage(Image image) async {
    File file = await File(await this.getUniqueFilePath()).create();
    file.writeAsBytesSync(encodePng(image));
    return file;
  }

  Future<Image> cropImageToSudokuBounds(Image fullImage) async {
    this.setPhotoSizeProperties(fullImage);
    return copyCrop(
      fullImage,
      my_values.sudokuPhotoRect.left.floor(),
      my_values.sudokuPhotoRect.top.floor(),
      my_values.fullPhotoSize.width.floor(),
      my_values.fullPhotoSize.height.floor(),
    );
  }

  Future<Image> cropSudokuImageToTileBounds(Image sudokuImage, TileKey tileKey) async {
    return copyCrop(
      sudokuImage,
      ((tileKey.col - 1) * my_values.fullPhotoSize.width / 9.0).floor(),
      ((tileKey.row - 1) * my_values.fullPhotoSize.height / 9.0).floor(),
      (my_values.fullPhotoSize.width / 9.0).floor(),
      (my_values.fullPhotoSize.height / 9.0).floor(),
    );
  }

  Future<HashMap<TileKey, File>> createTileFileMap(Image sudokuImage) async {
    HashMap<TileKey, File> _tileFileMap = HashMap<TileKey, File>();
    for (int row = 1; row < 9; row++) {
      for (int col = 1; col < 9; col++) {
        Image tileImage = await cropSudokuImageToTileBounds(sudokuImage, TileKey(row: row, col: col));
        _tileFileMap[TileKey(row: row, col: col)] = await this.getFileFromImage(tileImage);
      }
    }
    return _tileFileMap;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Future<int> getValueFromTileImageFile(File tileImageFile) async {
    FirebaseVisionImage firebaseVisionImage = FirebaseVisionImage.fromFile(tileImageFile);
    TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(firebaseVisionImage);

    int tileValue;

    for (TextBlock textBlock in visionText.blocks) {
      for (TextLine textLine in textBlock.lines) {
        for (TextElement textElement in textLine.elements) {
          if (this.isNumeric(textElement.text) && textElement.text.length == 1) {
            tileValue = int.parse(textElement.text);
          }
        }
      }
    }

    return tileValue;
  }

  Future<Sudoku> getSudokuFromTileImageMap(HashMap<TileKey, File> tileImageMap) async {
    Sudoku sudoku = Sudoku(tileStateMap: TileState.initTileStateMap());

    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        File tileImageFile = tileImageMap[TileKey(row: row, col: col)];
        int tileValue = await this.getValueFromTileImageFile(tileImageFile);
        sudoku.addValueToTile(tileValue, sudoku.getTileStateAt(row, col));
      }
    }
    return sudoku;
  }

  Future<void> getSudokuFromCamera() async {
    File fullImageFile = await this.getImageFileFromCamera();
    Image fullImage = await this.getImageFromFile(fullImageFile);
    Image sudokuImage = await this.cropImageToSudokuBounds(fullImage);
    HashMap<TileKey, File> tileImageMap = await this.createTileFileMap(sudokuImage);
    Sudoku sudoku = await this.getSudokuFromTileImageMap(tileImageMap);
    Redux.store.dispatch(PhotoProcessedAction(sudoku));
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
