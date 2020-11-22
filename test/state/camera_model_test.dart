import 'dart:ui';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';

import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

void main() {
  CameraState cameraState;

  // void setPathMockForTesting() {
  //   const MethodChannel('plugins.flutter.io/path_provider')
  //       .setMockMethodCallHandler((MethodCall methodCall) async {
  //     if (methodCall.method == 'getApplicationDocumentsDirectory') {
  //       final Directory directory = await Directory.systemTemp.createTemp();
  //       return directory.path;
  //     }
  //     return null;
  //   });

  //   const MethodChannel('plugins.flutter.io/firebase_ml_vision')
  //       .setMockMethodCallHandler((MethodCall methodCall) async {
  //     if (methodCall.method == 'TextRecognizer#processImage') {
  //       return {};
  //     }
  //     return null;
  //   });
  // }

  // Image getImageFromFile(File file) {
  //   return decodeImage(file.readAsBytesSync());
  // }

  // Future<Image> getCroppedImageFromFilePath(String path) async {
  //   File imageFile = await cameraState.getImageFileFromAssets(path);
  //   File imageFileCropped = await cameraState.cropPictureToSudokuSize(imageFile);
  //   return getImageFromFile(imageFileCropped);
  // }

  group('CameraState ->', () {
    setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

    setUp(() async {
      cameraState = CameraState();
      await SharedPreferences.setMockInitialValues({});
      await Redux.init();
    });

    test('initialised with correct values', () {
      expect(cameraState, isNotNull);
    });

    test('isNumeric() returns true when String is a number, and false otherwise', () {
      expect(cameraState.isNumeric('10'), true);
      expect(cameraState.isNumeric('10 '), true);
      expect(cameraState.isNumeric('a'), false);
      expect(cameraState.isNumeric('3a'), false);
    });

    test('copyWith() returns a new object', () {
      CameraState cloneCameraState = cameraState.copyWith();
      expect(cameraState == cloneCameraState, false);
    });

    group('calculateOverlapArea()', () {
      test('returns 0.0 when rectangles have no overlap', () async {
        expect(cameraState.calculateOverlapArea(Rect.fromLTRB(0, 0, 10, 10), Rect.fromLTRB(100, 100, 110, 110)), 0.0);
      });

      test('returns correct area when rectangles have some overlap', () async {
        expect(cameraState.calculateOverlapArea(Rect.fromLTRB(0, 0, 10, 10), Rect.fromLTRB(0, 0, 10, 5)), 50.0);
      });

      test('returns correct area when rectangles have completely overlap', () async {
        expect(cameraState.calculateOverlapArea(Rect.fromLTRB(0, 0, 10, 10), Rect.fromLTRB(0, 0, 10, 10)), 100.0);
      });
    });

    group('isInSudokuBounds()', () {
      setUp(() {
        my_values.photoRect = Rect.fromLTRB(0, 0, 10, 10);
      });
      tearDown(() {
        my_values.photoRect = null;
      });
      test('returns false when rectangles have no overlap', () async {
        expect(cameraState.isInSudokuBounds(Rect.fromLTRB(100, 100, 110, 110)), false);
      });

      test('returns true when rectangles have some overlap', () async {
        expect(cameraState.isInSudokuBounds(Rect.fromLTRB(0, 0, 10, 5)), true);
      });

      test('returns true when rectangles have completely overlap', () async {
        expect(cameraState.isInSudokuBounds(Rect.fromLTRB(0, 0, 10, 10)), true);
      });
    });

    group('isSudokuElement()', () {
      Rect validRect = Rect.fromLTRB(0, 0, 10, 10);

      setUp(() {
        my_values.photoRect = Rect.fromLTRB(0, 0, 10, 10);
      });

      test('returns true value 1-9', () async {
        expect(cameraState.isSudokuElement(MockTextElement('1', validRect)), true);
      });

      test('returns false for values other than 1-9', () async {
        expect(cameraState.isSudokuElement(MockTextElement('0', validRect)), false);
        expect(cameraState.isSudokuElement(MockTextElement('-1', validRect)), false);
      });

      test('returns false for multi-digit values', () async {
        expect(cameraState.isSudokuElement(MockTextElement('10', validRect)), false);
        expect(cameraState.isSudokuElement(MockTextElement('01', validRect)), false);
      });
    });

    group('makeTileRect()', () {
      setUp(() {
        my_values.photoRect = Rect.fromLTRB(0, 0, 900, 900);
      });

      test('returns valid rect', () async {
        expect(cameraState.makeTileRect(1, 1), Rect.fromLTRB(0, 0, 100, 100));
        expect(cameraState.makeTileRect(1, 9), Rect.fromLTRB(800, 0, 900, 100));
        expect(cameraState.makeTileRect(9, 1), Rect.fromLTRB(0, 800, 100, 900));
        expect(cameraState.makeTileRect(9, 9), Rect.fromLTRB(800, 800, 900, 900));
        expect(cameraState.makeTileRect(5, 5), Rect.fromLTRB(400, 400, 500, 500));
      });
    });

    group('mostLikelyTileForTextElement()', () {
      Sudoku sudoku;
      setUp(() {
        my_values.photoRect = Rect.fromLTRB(100, 100, 1000, 1000);
        sudoku = Sudoku(tileStateMap: TileState.initTileStateMap());
      });

      test('returns tile with most area overlap', () async {
        expect(
          cameraState.mostLikelyTileForTextElement(Rect.fromLTRB(102, 105, 140, 140), sudoku),
          sudoku.getTileStateAt(1, 1),
        );

        expect(
          cameraState.mostLikelyTileForTextElement(Rect.fromLTRB(400, 450, 500, 520), sudoku),
          sudoku.getTileStateAt(4, 4),
        );
      });
    });
  });
}

class MockTextElement implements TextElement {
  final String text;
  final Rect boundingBox;
  MockTextElement(
    this.text,
    this.boundingBox,
  );

  @override
  double get confidence => throw UnimplementedError();

  @override
  List<Offset> get cornerPoints => throw UnimplementedError();

  @override
  List<RecognizedLanguage> get recognizedLanguages => throw UnimplementedError();
}
