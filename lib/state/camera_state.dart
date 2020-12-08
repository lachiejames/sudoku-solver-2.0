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

File fullImageGlobal;
File croppedImageGlobal;
File sudokuImageGlobal;
File tileImageGlobal;

/// All state relating to the Camera
class CameraState {
  final CameraController cameraController;
  final Size screenSize;
  final Rect cameraWidgetBounds;

  CameraState({this.cameraController, this.screenSize, this.cameraWidgetBounds});

  Future<String> getUniqueFilePath() async {
    return join((await getApplicationDocumentsDirectory()).path, '${Random().nextDouble()}.png');
  }

  Future<void> _writeFileToAssets(String fileName, List<int> bytes) async {
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    File file = await File('$path/$fileName').create();
    await file.writeAsBytes(bytes);
  }

  Future<File> getImageFileFromCamera() async {
    String imagePath = await getUniqueFilePath();

    try {
      await this.cameraController.takePicture(imagePath);
    } on Exception catch (e) {
      print(e);
    }

    File imageFile = await File(imagePath).create();

    // await _writeFileToAssets('full_photo_low_res.png', imageFile.readAsBytesSync());
    // print('file creation complete');

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

  Future<Image> correctFullImage(Image fullImage, Size photoToScreenRatio) async {
    if (photoToScreenRatio.width > photoToScreenRatio.height) {
      int newWidth = (fullImage.width * photoToScreenRatio.height / photoToScreenRatio.width).floor();
      return copyCrop(
        fullImage,
        ((fullImage.width - newWidth) / 2.0).floor(),
        0,
        newWidth,
        fullImage.height,
      );
    } else {
      int newHeight = (fullImage.height * photoToScreenRatio.width / photoToScreenRatio.height).floor();
      return copyCrop(
        fullImage,
        0,
        ((fullImage.width - newHeight) / 2.0).floor(),
        fullImage.width,
        newHeight,
      );
    }
  }

  Future<Image> cropImageToSudokuBounds(Image fullImage) async {
    Size photoToScreenRatio = Size(
      fullImage.width / this.screenSize.width,
      fullImage.height / this.screenSize.height,
    );
    print('width=${fullImage.width}, height=${fullImage.height}');

    // Crop to aspect ratio if necessary
    // if (photoToScreenRatio.width != photoToScreenRatio.height) {
    //   fullImage = await this.correctFullImage(fullImage, photoToScreenRatio);
    //   photoToScreenRatio = Size(
    //     fullImage.width / this.screenSize.width,
    //     fullImage.height / this.screenSize.height,
    //   );
    //   croppedImageGlobal = await this.getFileFromImage(fullImage);
    // }

    // int x = (photoToScreenRatio.width * this.cameraWidgetBounds.left).floor();
    // int y = (photoToScreenRatio.height * this.cameraWidgetBounds.top).floor();
    // int width = (photoToScreenRatio.width * this.cameraWidgetBounds.right - x).floor();
    // int height = (photoToScreenRatio.height * this.cameraWidgetBounds.bottom - y).floor();

    return copyCrop(
      fullImage,
      0, // x,
      800, // y,
      fullImage.width, // width,
      fullImage.width,
    );
  }

  Future<Image> cropSudokuImageToTileBounds(Image sudokuImage, TileKey tileKey) async {
    int tolerance = 10;
    double x = (tileKey.col - 1) * sudokuImage.width / 9.0;
    if ((x - tolerance) >= 0) {
      x -= tolerance;
    }
    double y = (tileKey.row - 1) * sudokuImage.height / 9.0;
    if ((y - tolerance) >= 0) {
      y -= tolerance;
    }
    double width = sudokuImage.width / 9.0 + tolerance;
    double height = sudokuImage.height / 9.0 + tolerance;

    return copyCrop(
      sudokuImage,
      x.floor(),
      y.floor(),
      width.floor(),
      height.floor(),
    );
  }

  Future<HashMap<TileKey, File>> createTileFileMap(Image sudokuImage) async {
    HashMap<TileKey, File> _tileFileMap = HashMap<TileKey, File>();
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        Image tileImage = await cropSudokuImageToTileBounds(sudokuImage, TileKey(row: row, col: col));
        _tileFileMap[TileKey(row: row, col: col)] = await this.getFileFromImage(tileImage);
        if (row == 1 && col == 1) {
          tileImageGlobal = _tileFileMap[TileKey(row: row, col: col)];
        }
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
    fullImageGlobal = fullImageFile;
    Image fullImage = await this.getImageFromFile(fullImageFile);
    Image sudokuImage = await this.cropImageToSudokuBounds(fullImage);
    sudokuImageGlobal = await this.getFileFromImage(sudokuImage);
    HashMap<TileKey, File> tileFileMap = await this.createTileFileMap(sudokuImage);

    Sudoku sudoku = await this.getSudokuFromTileImageMap(tileFileMap);

    Redux.store.dispatch(PhotoProcessedAction(sudoku));

    my_values.takePhotoButtonPressedTrace.stop();
  }

  CameraState copyWith({CameraController cameraController, Size screenSize, Rect cameraWidgetBounds}) {
    return CameraState(
      cameraController: cameraController ?? this.cameraController,
      screenSize: screenSize ?? this.screenSize,
      cameraWidgetBounds: cameraWidgetBounds ?? this.cameraWidgetBounds,
    );
  }

  static CameraState initCameraState() {
    return CameraState(
      cameraController: null,
    );
  }
}
