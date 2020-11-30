import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';

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
        File mockImageFile = await TestConstants.getImageFileFromAssets('full_photo_max_res.png');
        mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
      }
      return null;
    });
  }

  group('CameraState ->', () {
    setUp(() async {
      await SharedPreferences.setMockInitialValues({});
      await Redux.init();
      cameraState = Redux.store.state.cameraState;
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

    group('cropImageToSudokuBounds()', () {
      Image fullImage;
      group('max res image', () {
        setUp(() async {
          Redux.store.dispatch(SetCameraStateProperties(
            screenSize: Size(360.0, 722.7),
            cameraWidgetBounds: Rect.fromLTRB(32.0, 213.3, 328.0, 509.3),
          ));
          cameraState = Redux.store.state.cameraState;

          File file = await TestConstants.getImageFileFromAssets("full_photo_max_res.png");
          fullImage = await cameraState.getImageFromFile(file);
        });

        test('screenSize has been set', () async {
          expect(cameraState.screenSize.width, 360.0);
          expect(cameraState.screenSize.height, 722.7);
        });

        test('cameraWidgetBounds has been set', () async {
          expect(cameraState.cameraWidgetBounds.left, 32.0);
          expect(cameraState.cameraWidgetBounds.top, 213.3);
          expect(cameraState.cameraWidgetBounds.right, 328.0);
          expect(cameraState.cameraWidgetBounds.bottom, 509.3);
        });

        test('crops sudoku to expected size', () async {
          Image croppedPhoto = await cameraState.cropImageToSudokuBounds(fullImage);
          expect(croppedPhoto.width, 1776);
          expect(croppedPhoto.height, 1573);
        });
      });
      group('medium res image', () {
        setUp(() async {
          File file = await TestConstants.getImageFileFromAssets("full_photo_medium_res.png");
          fullImage = await cameraState.getImageFromFile(file);
        });
      });
      group('low res image', () {
        setUp(() async {
          File file = await TestConstants.getImageFileFromAssets("full_photo_low_res.png");
          fullImage = await cameraState.getImageFromFile(file);
        });
      });
    });

    group('getImageFromFile()', () {
      test('returns a valid image', () async {
        File file = await TestConstants.getImageFileFromAssets("full_photo_max_res.png");
        Image image = await cameraState.getImageFromFile(file);
        expect(image, isNotNull);
        expect(image.length > 0, true);
      });
      test('is expected size', () async {
        File file = await TestConstants.getImageFileFromAssets("full_photo_max_res.png");
        Image image = await cameraState.getImageFromFile(file);
        expect(image.width, 2160);
        expect(image.height, 3840);
      });
    });

    group('getFileFromImage()', () {
      test('returns a valid file', () async {
        File file = await TestConstants.getImageFileFromAssets("full_photo_max_res.png");
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
