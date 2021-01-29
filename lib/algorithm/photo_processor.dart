import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

const double _verticalPhotoScaleFactor = 0.21875;
CancelableOperation<dynamic> _processPhotoCancellableOperation;
String _appFolder;

Future<Image> _getImageFromFile(File file) async => bakeOrientation(decodeImage(file.readAsBytesSync()));

Future<File> _getFileFromImage(Image image) async {
  final File file = await File(await getUniqueFilePath()).create();
  file.writeAsBytesSync(encodePng(image));
  return file;
}

Future<Image> _cropImageToSudokuBounds(Image fullImage) async => copyCrop(
      fullImage,
      0,
      (_verticalPhotoScaleFactor * fullImage.height).floor(),
      fullImage.width,
      fullImage.width,
    );

Future<Image> _cropSudokuImageToTileBounds(Image sudokuImage, TileKey tileKey) async {
  final double tolerance = sudokuImage.width / 100;
  final double tileSize = sudokuImage.width / 9.0;

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
  final HashMap<TileKey, File> _tileFileMap = HashMap<TileKey, File>();
  for (int row = 1; row <= 9; row++) {
    for (int col = 1; col <= 9; col++) {
      final Image tileImage = await _cropSudokuImageToTileBounds(sudokuImage, TileKey(row: row, col: col));
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
  final FirebaseVisionImage firebaseVisionImage = FirebaseVisionImage.fromFile(tileImageFile);
  final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
  VisionText visionText;

  visionText = await textRecognizer.processImage(firebaseVisionImage);

  for (final TextBlock textBlock in visionText.blocks) {
    for (final TextLine textLine in textBlock.lines) {
      for (final TextElement textElement in textLine.elements) {
        final String text = textElement.text.replaceAll('|', '');
        if (_isNumeric(text) && text.length == 1) {
          return int.parse(text);
        }
      }
    }
  }

  return null;
}

Future<Sudoku> _getSudokuFromTileImageMap(HashMap<TileKey, File> tileImageMap) async {
  final Sudoku sudoku = Sudoku(tileStateMap: TileState.initTileStateMap());

  for (int row = 1; row <= 9; row++) {
    for (int col = 1; col <= 9; col++) {
      final File tileImageFile = tileImageMap[TileKey(row: row, col: col)];
      final int tileValue = await _getValueFromTileImageFile(tileImageFile);
      sudoku.addValueToTile(tileValue, sudoku.getTileStateAt(row, col));
    }
  }
  return sudoku;
}

Future<HashMap<TileKey, File>> getTileFileMapFromImageFile(dynamic data) async {
  _appFolder = data['appFolder'];
  final Image fullImage = await _getImageFromFile(data['imageFile']);
  final Image sudokuImage = await _cropImageToSudokuBounds(fullImage);
  return _createTileFileMap(sudokuImage);
}

Future<void> processPhoto(File imageFile) async {
  _processPhotoCancellableOperation =
      CancelableOperation<dynamic>.fromFuture(compute(getTileFileMapFromImageFile, <String, dynamic>{
    'imageFile': imageFile,
    'appFolder': (await getApplicationDocumentsDirectory()).path,
  }));

  _processPhotoCancellableOperation.asStream().listen((dynamic tileFileMap) async {
    if (tileFileMap != null) {
      try {
        final Sudoku constructedSudoku = await _getSudokuFromTileImageMap(tileFileMap);
        await playSound(photoProcessedSound);
        await takePhotoButtonPressedTrace.stop();
        Redux.store.dispatch(PhotoProcessedAction(constructedSudoku));
      } on Exception catch (e) {
        await logError('ERROR: photo could not be processed', e);
        await playSound(processingErrorSound);
        Redux.store.dispatch(PhotoProcessingErrorAction());
      }
    }
  }, onError: (dynamic e) async {
    await playSound(processingErrorSound);
    Redux.store.dispatch(PhotoProcessingErrorAction());
  });
}

void stopProcessingPhoto() {
  _processPhotoCancellableOperation.cancel();
}

Future<String> getUniqueFilePath() async {
  _appFolder ??= (await getApplicationDocumentsDirectory()).path;
  return join(_appFolder, '${Random().nextDouble()}.png');
}
