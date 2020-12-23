import 'dart:collection';
import 'dart:io';
import 'dart:math';
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
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

final double _verticalPhotoScaleFactor = 0.21875;
CancelableOperation _processPhotoCancellableOperation;

Future<Image> _getImageFromFile(File file) async {
  return bakeOrientation(decodeImage(file.readAsBytesSync()));
}

Future<File> _getFileFromImage(Image image) async {
  print('xxx 1');

  File file = await File("/data/user/0/com.lachie.sudoku_solver_2/app_flutter/0.04504844281578424.png").create();
  // File file = await File(await getUniqueFilePath()).create();
  print('xxx 2');

  file.writeAsBytesSync(encodePng(image));
  return file;
}

Future<Image> _cropImageToSudokuBounds(Image fullImage) async {
  return copyCrop(
    fullImage,
    0,
    (_verticalPhotoScaleFactor * fullImage.height).floor(),
    fullImage.width,
    fullImage.width,
  );
}

Future<Image> _cropSudokuImageToTileBounds(Image sudokuImage, TileKey tileKey) async {
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

Future<HashMap<TileKey, File>> _createTileFileMap(Image sudokuImage) async {
  HashMap<TileKey, File> _tileFileMap = HashMap<TileKey, File>();
  for (int row = 1; row <= 9; row++) {
    for (int col = 1; col <= 9; col++) {
      Image tileImage = await _cropSudokuImageToTileBounds(sudokuImage, TileKey(row: row, col: col));
      _tileFileMap[TileKey(row: row, col: col)] = await _getFileFromImage(tileImage);
    }
  }

  return _tileFileMap;
}

bool _isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

Future<int> _getValueFromTileImageFile(File tileImageFile) async {
  FirebaseVisionImage firebaseVisionImage = FirebaseVisionImage.fromFile(tileImageFile);
  TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
  VisionText visionText;

  visionText = await textRecognizer.processImage(firebaseVisionImage);

  for (TextBlock textBlock in visionText.blocks) {
    for (TextLine textLine in textBlock.lines) {
      for (TextElement textElement in textLine.elements) {
        String text = textElement.text.replaceAll("|", "");
        if (_isNumeric(text) && text.length == 1) {
          return int.parse(text);
        }
      }
    }
  }

  return null;
}

Future<Sudoku> _getSudokuFromTileImageMap(HashMap<TileKey, File> tileImageMap) async {
  Sudoku sudoku = Sudoku(tileStateMap: TileState.initTileStateMap());

  for (int row = 1; row <= 9; row++) {
    for (int col = 1; col <= 9; col++) {
      File tileImageFile = tileImageMap[TileKey(row: row, col: col)];
      int tileValue = await _getValueFromTileImageFile(tileImageFile);
      sudoku.addValueToTile(tileValue, sudoku.getTileStateAt(row, col));
    }
  }
  return sudoku;
}

Future<String> getUniqueFilePath() async {
  return join((await getApplicationDocumentsDirectory()).path, '${Random().nextDouble()}.png');
}

Future<Sudoku> getSudokuFromImageFile(File imageFile) async {
  Image fullImage = await _getImageFromFile(imageFile);
  Image sudokuImage = await _cropImageToSudokuBounds(fullImage);
  HashMap<TileKey, File> tileFileMap = await _createTileFileMap(sudokuImage);
  Sudoku sudoku = await _getSudokuFromTileImageMap(tileFileMap);

  Redux.store.dispatch(PhotoProcessedAction(sudoku));
  my_values.takePhotoButtonPressedTrace.stop();
  print('xxx - complete');

  return sudoku;
}

Future<void> processPhoto(File imageFile) async {
  _processPhotoCancellableOperation = CancelableOperation.fromFuture(
    compute(getSudokuFromImageFile, imageFile),
  );

  _processPhotoCancellableOperation.asStream().listen(
    (constructedSudoku) {
      print('xxx - $constructedSudoku');
      Redux.store.dispatch(PhotoProcessedAction(constructedSudoku));
      my_values.takePhotoButtonPressedTrace.stop();
    },
  );
}

void stopProcessingPhoto() {
  _processPhotoCancellableOperation.cancel();
}
