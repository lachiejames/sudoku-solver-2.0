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

  CameraState({this.cameraController, this.screenSize});

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

  Future<Image> cropImageToSudokuBounds(Image fullImage) async {
    int x = 0;
    int y = 850;
    print('xxx screenWidth=${this.screenSize.width}');
    print('screenHeight=${this.screenSize.height}');
    print('fullImageWidth=${fullImage.width}');
    print('fullImageHeight=${fullImage.height}');
    print('croppedImageHeight=${fullImage.width}');
    print('croppedImageWidth=${fullImage.width}');
    print('croppedImageX=$x');
    print('croppedImageY=$y');
    return copyCrop(
      fullImage,
      x, // x,
      y, // y,
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
    // HashMap<TileKey, File> tileFileMap = await this.createTileFileMap(sudokuImage);
    //
    // Sudoku sudoku = await this.getSudokuFromTileImageMap(tileFileMap);
    //
    // Redux.store.dispatch(PhotoProcessedAction(sudoku));
    // print(sudoku);
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
