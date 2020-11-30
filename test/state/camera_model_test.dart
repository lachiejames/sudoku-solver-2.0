import 'dart:collection';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';

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

    // const MethodChannel('plugins.flutter.io/firebase_ml_vision')
    //     .setMockMethodCallHandler((MethodCall methodCall) async {
    //   if (methodCall.method == 'TextRecognizer#processImage') {
    //     return {};
    //   }
    //   return null;
    // });

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
      setUp(() async {
        Redux.store.dispatch(SetCameraStateProperties(
          screenSize: Size(360.0, 722.7),
          cameraWidgetBounds: Rect.fromLTRB(32.0, 213.3, 328.0, 509.3),
        ));
        cameraState = Redux.store.state.cameraState;
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

      group('max res image', () {
        setUp(() async {
          File file = await TestConstants.getImageFileFromAssets("full_photo_max_res.png");
          fullImage = await cameraState.getImageFromFile(file);
        });

        test('crops sudoku to expected size', () async {
          Image croppedPhoto = await cameraState.cropImageToSudokuBounds(fullImage);
          expect(croppedPhoto.width, 1573);
          expect(croppedPhoto.height, 1573);
        });
      });
      group('medium res image', () {
        setUp(() async {
          File file = await TestConstants.getImageFileFromAssets("full_photo_medium_res.png");
          fullImage = await cameraState.getImageFromFile(file);
        });

        test('crops sudoku to expected size', () async {
          Image croppedPhoto = await cameraState.cropImageToSudokuBounds(fullImage);
          expect(croppedPhoto.width, 295);
          expect(croppedPhoto.height, 295);
        });
      });
      group('low res image', () {
        setUp(() async {
          File file = await TestConstants.getImageFileFromAssets("full_photo_low_res.png");
          fullImage = await cameraState.getImageFromFile(file);
        });

        test('crops sudoku to expected size', () async {
          Image croppedPhoto = await cameraState.cropImageToSudokuBounds(fullImage);
          expect(croppedPhoto.width, 130);
          expect(croppedPhoto.height, 131);
        });
      });
    });

    group('cropSudokuImageToTileBounds()', () {
      Image sudokuImage;
      setUp(() async {
        Redux.store.dispatch(SetCameraStateProperties(
          screenSize: Size(360.0, 722.7),
          cameraWidgetBounds: Rect.fromLTRB(32.0, 213.3, 328.0, 509.3),
        ));
        cameraState = Redux.store.state.cameraState;
      });

      group('max res image', () {
        setUp(() async {
          File file = await TestConstants.getImageFileFromAssets("full_photo_max_res.png");
          Image fullImage = await cameraState.getImageFromFile(file);
          sudokuImage = await cameraState.cropImageToSudokuBounds(fullImage);
        });

        test('crops sudoku to expected size for Tile(1,1)', () async {
          Image tilePhoto = await cameraState.cropSudokuImageToTileBounds(
            sudokuImage,
            TileKey(row: 1, col: 1),
          );
          expect(tilePhoto.width, 174);
          expect(tilePhoto.height, 174);
        });

        test('crops sudoku to expected size for Tile(9,9)', () async {
          Image tilePhoto = await cameraState.cropSudokuImageToTileBounds(
            sudokuImage,
            TileKey(row: 9, col: 9),
          );
          expect(tilePhoto.width, 174);
          expect(tilePhoto.height, 174);
        });
      });
      group('medium res image', () {
        setUp(() async {
          File file = await TestConstants.getImageFileFromAssets("full_photo_medium_res.png");
          Image fullImage = await cameraState.getImageFromFile(file);
          sudokuImage = await cameraState.cropImageToSudokuBounds(fullImage);
        });

        test('crops sudoku to expected size for Tile(1,1)', () async {
          Image tilePhoto = await cameraState.cropSudokuImageToTileBounds(
            sudokuImage,
            TileKey(row: 1, col: 1),
          );
          expect(tilePhoto.width, 32);
          expect(tilePhoto.height, 32);
        });

        test('crops sudoku to expected size for Tile(9,9)', () async {
          Image tilePhoto = await cameraState.cropSudokuImageToTileBounds(
            sudokuImage,
            TileKey(row: 9, col: 9),
          );
          expect(tilePhoto.width, 32);
          expect(tilePhoto.height, 32);
        });
      });
      group('low res image', () {
        setUp(() async {
          File file = await TestConstants.getImageFileFromAssets("full_photo_low_res.png");
          Image fullImage = await cameraState.getImageFromFile(file);
          sudokuImage = await cameraState.cropImageToSudokuBounds(fullImage);
        });

        test('crops sudoku to expected size for Tile(1,1)', () async {
          Image tilePhoto = await cameraState.cropSudokuImageToTileBounds(
            sudokuImage,
            TileKey(row: 1, col: 1),
          );
          expect(tilePhoto.width, 14);
          expect(tilePhoto.height, 14);
        });

        test('crops sudoku to expected size for Tile(9,9)', () async {
          Image tilePhoto = await cameraState.cropSudokuImageToTileBounds(
            sudokuImage,
            TileKey(row: 9, col: 9),
          );
          expect(tilePhoto.width, 14);
          expect(tilePhoto.height, 14);
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

    group('createTileFileMap()', () {
      Image sudokuImage;
      setUp(() async {
        Redux.store.dispatch(SetCameraStateProperties(
          screenSize: Size(360.0, 722.7),
          cameraWidgetBounds: Rect.fromLTRB(32.0, 213.3, 328.0, 509.3),
        ));
        cameraState = Redux.store.state.cameraState;

        File file = await TestConstants.getImageFileFromAssets("full_photo_max_res.png");
        Image fullImage = await cameraState.getImageFromFile(file);
        sudokuImage = await cameraState.cropImageToSudokuBounds(fullImage);
      });

      test('returns valid tilemap', () async {
        HashMap<TileKey, File> tileFileMap = await cameraState.createTileFileMap(sudokuImage);
        expect(tileFileMap, isNotNull);
      });
      test('files are valid', () async {
        HashMap<TileKey, File> tileFileMap = await cameraState.createTileFileMap(sudokuImage);

        for (File file in tileFileMap.values) {
          expect(file, isNotNull);
          expect(file.existsSync(), true);
        }
      });
      test('all file paths are unique', () async {
        HashMap<TileKey, File> tileFileMap = await cameraState.createTileFileMap(sudokuImage);

        List<String> filePathList = [];
        Set<String> filePathSet = {};

        for (File file in tileFileMap.values) {
          filePathList.add(file.path);
          filePathSet.add(file.path);
        }
        expect(filePathList.length, filePathSet.length);
      });
    });

    group('getValueFromTileImageFile()', () {
      Image sudokuImage;
      setUp(() async {
        Redux.store.dispatch(SetCameraStateProperties(
          screenSize: Size(360.0, 722.7),
          cameraWidgetBounds: Rect.fromLTRB(32.0, 213.3, 328.0, 509.3),
        ));
        cameraState = Redux.store.state.cameraState;

        File file = await TestConstants.getImageFileFromAssets("full_photo_max_res.png");
        Image fullImage = await cameraState.getImageFromFile(file);
        sudokuImage = await cameraState.cropImageToSudokuBounds(fullImage);
      });
      // test('for image with no text, returns null', () async {
      //   HashMap<TileKey, File> tileFileMap = await cameraState.createTileFileMap(sudokuImage);
      //   File fileToBeRead = tileFileMap[TileKey(row: 1, col: 1)];
      //   int value = await cameraState.getValueFromTileImageFile(fileToBeRead);
      //   expect(value, 5);
      // });
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
