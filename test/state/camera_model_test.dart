import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;

import '../constants/test_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  CameraState cameraState;

  Future<void> setMocks() async {
    const MethodChannel('plugins.flutter.io/path_provider').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return TestConstants.getTempDirectory();
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
        File mockImageFile = await TestConstants.getImageFileFromAssets('sudoku_screenshot.png');
        mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
      }
      return null;
    });
  }

  group('CameraState ->', () {
    setUp(() async {
      cameraState = CameraState();
      await SharedPreferences.setMockInitialValues({});
      await Redux.init();
      await setMocks();
    });

    tearDown(() async {
      await TestConstants.deleteCreatedFiles();
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
        cameraState = CameraState(cameraController: TestConstants.getMockCameraController());
        File file = await cameraState.getImageFileFromCamera();
        expect(file, isNotNull);
        expect(file.existsSync(), true);
      });
    });

    group('setPhotoSizeProperties()', () {
      setUp(() {
        my_values.cameraWidgetSize = Size(300, 300);
        my_values.cameraWidgetRect = Rect.fromLTRB(30, 30, 30, 30);
      });
      test('fullPhotoSize matches size of photo', () async {
        File file = await TestConstants.getImageFileFromAssets("sudoku_screenshot.png");
        Image image = await cameraState.getImageFromFile(file);
        cameraState.setPhotoSizeProperties(image);
        expect(my_values.fullPhotoSize.width, 410);
        expect(my_values.fullPhotoSize.height, 731);
      });
      test('for a 720x1080 image, sets sudokuPhotoSize to ...', () {});
      test('for a 720x1080 image, sets tilePhotoSize to ...', () {});
    });

    group('getImageFromFile()', () {
      test('returns a valid image', () async {
        File file = await TestConstants.getImageFileFromAssets("sudoku_screenshot.png");
        Image image = await cameraState.getImageFromFile(file);
        expect(image, isNotNull);
        expect(image.length > 0, true);
      });
      test('is expected size', () async {
        File file = await TestConstants.getImageFileFromAssets("sudoku_screenshot.png");
        Image image = await cameraState.getImageFromFile(file);
        expect(image.width, 410);
        expect(image.height, 731);
      });
    });

    group('getFileFromImage()', () {
      test('returns a valid file', () async {
        File file = await TestConstants.getImageFileFromAssets("sudoku_screenshot.png");
        Image image = await cameraState.getImageFromFile(file);
        file = await cameraState.getFileFromImage(image);
        expect(file, isNotNull);
        expect(file.existsSync(), true);
      });
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
