import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  CameraState cameraState;

  Future<File> getImageFileFromAssets(String path) async {
    ByteData byteData;
    try {
      byteData = await rootBundle.load('assets/$path');
    } on Exception catch (e) {
      print('ERROR: no file found at assets/$path\n $e');
      return null;
    }
    File file = await File('${(await getApplicationDocumentsDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  CameraController getMockCameraController() {
    return CameraController(
      CameraDescription(
        name: "mock",
        lensDirection: CameraLensDirection.front,
        sensorOrientation: 0,
      ),
      ResolutionPreset.high,
    );
  }

  Future<void> setMocks() async {
    const MethodChannel('plugins.flutter.io/path_provider').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return "/data/user/0/com.lachie.sudoku_solver_2/app_flutter";
      }
      return null;
    });

    const MethodChannel('plugins.flutter.io/firebase_ml_vision')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'TextRecognizer#processImage') {
        return {};
      }
      return null;
    });

    const MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'takePicture') {
        String imagePath = methodCall.arguments['path'];
        File mockFile = await File(imagePath).create();
        File mockImageFile = await getImageFileFromAssets('sudoku_screenshot.png');
        mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
      }
      return null;
    });
  }

  // Image getImageFromFile(File file) {
  //   return decodeImage(file.readAsBytesSync());
  // }

  // Future<Image> getCroppedImageFromFilePath(String path) async {
  //   File imageFile = await cameraState.getImageFileFromAssets(path);
  //   File imageFileCropped = await cameraState.cropPictureToSudokuSize(imageFile);
  //   return getImageFromFile(imageFileCropped);
  // }

  group('CameraState ->', () {
    setUp(() async {
      cameraState = CameraState();
      await SharedPreferences.setMockInitialValues({});
      await Redux.init();
      await setMocks();
    });

    group('initialisation', () {
      test('cameraState is defined', () {
        expect(cameraState, isNotNull);
      });

      test('cameraController is null', () {
        expect(cameraState.cameraController, isNull);
      });
    });

    group('getUniqueFilePath()', () {
      test('returns a unique file path whenever it is called', () async {
        String filePath1 = await cameraState.getUniqueFilePath();
        String filePath2 = await cameraState.getUniqueFilePath();
        expect(filePath1 != filePath2, true);
      });
    });

    group('getImageFileFromCamera()', () {
      test('returns a valid file', () async {
        cameraState = CameraState(cameraController: getMockCameraController());
        File file = await cameraState.getImageFileFromCamera();
        expect(file, isNotNull);
      });
    });

    group('setPhotoSizeProperties()', () {
      test('for a 720x1080 image, sets sudokuPhotoRect to ...', () {});
      test('for a 720x1080 image, sets sudokuPhotoSize to ...', () {});
      test('for a 720x1080 image, sets tilePhotoSize to ...', () {});
    });

    group('getImageFromFile()', () {
      test('returns a valid file', () async {
        File file = await getImageFileFromAssets("sudoku_screenshot.png");
        Image image = await cameraState.getImageFromFile(file);
        expect(image, isNotNull);
      });
      test('is expected size', () {});
    });

    group('getFileFromImage()', () {
      test('returns a valid file', () {});
    });

    group('cropImageToSudokuBounds()', () {
      test('returns image of expected size', () {});
    });

    group('cropSudokuImageToTileBounds()', () {
      test('returns image of expected size for Tile(1,1)', () {});
      test('returns image of expected size for Tile(1,9)', () {});
      test('returns image of expected size for Tile(9,9)', () {});
      test('throws exception for Tile(0,9)', () {});
    });

    group('createTileFileMap()', () {
      test('returns valid tilemap', () {});
      test('files are valid', () {});
      test('all file paths are unique', () {});
    });

    group('getValueFromTileImageFile()', () {
      test('for image with no text, returns null', () {});
      test('for image with text="5", returns 5', () {});
      test('for image with text="1", returns 1', () {});
    });

    group('getSudokuFromTileImageMap()', () {
      test('returns expected sudoku for the given image', () {});
    });

    group('getSudokuFromCamera()', () {
      test('returns expected sudoku for the given image', () {});
    });
  });
}
