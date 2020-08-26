import 'dart:io';
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';

void main() {
  CameraState cameraState;

  void setPathMockForTesting() {
    const MethodChannel('plugins.flutter.io/path_provider').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        final Directory directory = await Directory.systemTemp.createTemp();
        return directory.path;
      }
      return null;
    });
  }

  group('CameraState ->', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      setPathMockForTesting();
    });

    setUp(() {
      cameraState = CameraState();
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

    test('getImageFileFromAssets() returns a file when a valid path is used', () async {
      File imageFileThatExists = await cameraState.getImageFileFromAssets('mock_sudoku.jpg');
      expect(imageFileThatExists, isNotNull);
    });

    test('getImageFileFromAssets() returns null when an invalid path is used', () async {
      File imageFileThatDoesNotExist = await cameraState.getImageFileFromAssets('path_to_nowhere.jpg');
      expect(imageFileThatDoesNotExist, null);
    });

    test('cropPictureToSudokuSize() returns a cropped version of the input file', () async {
      File largeImageFile = await cameraState.getImageFileFromAssets('mock_sudoku.jpg');
      MyValues.screenWidth = 460;
      MyValues.cameraWidth = 400;

      File smallImageFile = await cameraState.cropPictureToSudokuSize(largeImageFile);
      expect(smallImageFile, isNotNull);
    });
  });
}
