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
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

File sudokuImageFile;
// File originalImageFile;
// File croppedImageFile;

/// All state relating to the Camera
class CameraState {
  final CameraController cameraController;

  CameraState({this.cameraController});

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

  void setPhotoSizeProperties(Image fullImage) {
    double cameraAspectRatio = fullImage.height / fullImage.width;
    double screenAspectRatio = my_values.screenSize.height / my_values.screenSize.width;

    print('cameraAspectRatio=$cameraAspectRatio');
    print('screenAspectRatio=$screenAspectRatio');
    // originalImageFile = await this.getFileFromImage(fullImage);
    

    // Correct photo aspect ratio to match screen
    if (cameraAspectRatio != screenAspectRatio) {
      if (cameraAspectRatio < screenAspectRatio) {
        double requiredWidth = fullImage.height / screenAspectRatio;
        double requiredX = (fullImage.width - requiredWidth) / 2.0;
        fullImage = copyCrop(
          fullImage,
          requiredX.floor(),
          0,
          requiredWidth.floor(),
          fullImage.height,
        );
      } else {
        int requiredHeight = (fullImage.width * screenAspectRatio).floor();
        int requiredY = ((fullImage.height - requiredHeight) / 2.0).floor();
        fullImage = copyCrop(
          fullImage,
          0,
          requiredY,
          fullImage.width,
          requiredHeight,
        );
      }
    }
    // croppedImageFile = await this.getFileFromImage(fullImage);

    cameraAspectRatio = fullImage.height / fullImage.width;
    screenAspectRatio = my_values.screenSize.height / my_values.screenSize.width;

    print('cameraAspectRatio=$cameraAspectRatio');
    print('screenAspectRatio=$screenAspectRatio');

    my_values.fullPhotoSize = Size(fullImage.width.toDouble(), fullImage.height.toDouble());

    assert(my_values.cameraWidgetSize != null);

    double screenWidthToPhotoWidthRatio = my_values.fullPhotoSize.width / my_values.screenSize.width;
    double screenHeightToPhotoHeightRatio = my_values.fullPhotoSize.height / my_values.screenSize.height;
    print(screenWidthToPhotoWidthRatio);
    print(screenHeightToPhotoHeightRatio);

    my_values.sudokuPhotoRect = Rect.fromLTRB(
      screenWidthToPhotoWidthRatio * my_values.cameraWidgetRect.left,
      screenHeightToPhotoHeightRatio * my_values.cameraWidgetRect.top,
      screenWidthToPhotoWidthRatio * my_values.cameraWidgetRect.right,
      screenHeightToPhotoHeightRatio * my_values.cameraWidgetRect.bottom,
    );

    my_values.sudokuPhotoSize = Size(
      screenWidthToPhotoWidthRatio * my_values.cameraWidgetSize.width,
      screenHeightToPhotoHeightRatio * my_values.cameraWidgetSize.height,
    );

    my_values.tilePhotoSize = Size(
      my_values.sudokuPhotoSize.width / 9.0,
      my_values.sudokuPhotoSize.height / 9.0,
    );

    print('xxx - screenSize=${my_values.screenSize}');
    print('xxx - cameraWidgetSize=${my_values.cameraWidgetSize}');
    print('xxx - fullPhotoSize=${my_values.fullPhotoSize}');
    print('xxx - sudokuPhotoSize=${my_values.sudokuPhotoSize}');
    print('xxx - tilePhotoSize=${my_values.tilePhotoSize}');
    print('xxx - cameraWidgetRect=${my_values.cameraWidgetRect}');
    print('xxx - screenRect=${my_values.screenRect}');
    print('xxx - sudokuPhotoRect=${my_values.sudokuPhotoRect}');
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
    this.setPhotoSizeProperties(fullImage);
    return copyCrop(
      fullImage,
      my_values.sudokuPhotoRect.left.floor(),
      my_values.sudokuPhotoRect.top.floor(),
      my_values.sudokuPhotoSize.width.floor(),
      my_values.sudokuPhotoSize.height.floor(),
    );
  }

  Future<Image> cropSudokuImageToTileBounds(Image sudokuImage, TileKey tileKey) async {
    return copyCrop(
      sudokuImage,
      ((tileKey.col - 1) * my_values.sudokuPhotoSize.width / 9.0).floor(),
      ((tileKey.row - 1) * my_values.sudokuPhotoSize.height / 9.0).floor(),
      (my_values.sudokuPhotoSize.width / 9.0).floor(),
      (my_values.sudokuPhotoSize.height / 9.0).floor(),
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
    print(fullImage.width);
    print(fullImage.height);
    Image sudokuImage = await this.cropImageToSudokuBounds(fullImage);
    sudokuImageFile = await this.getFileFromImage(sudokuImage);
    // HashMap<TileKey, File> tileImageMap = await this.createTileFileMap(sudokuImage);
    // Sudoku sudoku = await this.getSudokuFromTileImageMap(tileImageMap);
    // Redux.store.dispatch(PhotoProcessedAction(sudoku));
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
