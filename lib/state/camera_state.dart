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
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;

/// All state relating to the Camera
class CameraState {
  final CameraController cameraController;
  final Size screenSize;
  final double _verticalPhotoScaleFactor = 0.21875;

  CameraState({this.cameraController, this.screenSize});

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

    File imageFile = await File(imagePath).create();

    return imageFile;
  }

  Future<Image> getImageFromFile(File file) async {
    return bakeOrientation(decodeImage(file.readAsBytesSync()));
  }

  Future<File> getFileFromImage(Image image) async {
    File file = await File(await this.getUniqueFilePath()).create();
    file.writeAsBytesSync(encodePng(image));
    return file;
  }

  Future<Image> cropImageToSudokuBounds(Image fullImage) async {
    return copyCrop(
      fullImage,
      0,
      (this._verticalPhotoScaleFactor * fullImage.height).floor(),
      fullImage.width,
      fullImage.width,
    );
  }

  Future<Image> cropSudokuImageToTileBounds(Image sudokuImage, TileKey tileKey) async {
    double tolerance = sudokuImage.width / 100;
    double tileSize = sudokuImage.width / 9.0;

    double x = (tileKey.col - 1) * tileSize;
    double y = (tileKey.row - 1) * tileSize;
    double width = tileSize + tolerance;
    double height = tileSize + tolerance;

    // If subtracting tolerance makes x or y negative, then don't
    if ((x - tolerance) >= 0) {
      x -= tolerance;
      width += tolerance;
    }
    if ((y - tolerance) >= 0) {
      y -= tolerance;
      height += tolerance;
    }

    return copyCrop(
      sudokuImage,
      x.floor(),
      y.floor(),
      width.ceil(),
      height.ceil(),
    );
  }

  Future<HashMap<TileKey, File>> createTileFileMap(Image sudokuImage) async {
    HashMap<TileKey, File> _tileFileMap = HashMap<TileKey, File>();
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
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
    VisionText visionText;

    try {
      visionText = await textRecognizer.processImage(firebaseVisionImage);
    } on Exception catch (e) {
      print(e);
      return 0;
    }

    for (TextBlock textBlock in visionText.blocks) {
      for (TextLine textLine in textBlock.lines) {
        for (TextElement textElement in textLine.elements) {
          String text = textElement.text.replaceAll("|", "");
          if (this.isNumeric(text) && text.length == 1) {
            return int.parse(text);
          }
        }
      }
    }

    return null;
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
    HashMap<TileKey, File> tileFileMap = await this.createTileFileMap(sudokuImage);

    Sudoku sudoku = await this.getSudokuFromTileImageMap(tileFileMap);
    if (sudoku.tileStateMap[TileKey(row: 1, col: 1)].value == 0) {
      // throw error
    } else {
      Redux.store.dispatch(PhotoProcessedAction(sudoku));
    }
    my_values.takePhotoButtonPressedTrace.stop();
  }

  CameraState copyWith({CameraController cameraController, Size screenSize, Rect cameraWidgetBounds}) {
    return CameraState(
      cameraController: cameraController ?? this.cameraController,
      screenSize: screenSize ?? this.screenSize,
    );
  }

  static CameraState initCameraState() {
    return CameraState(
      cameraController: null,
    );
  }
}
