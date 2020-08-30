import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image/image.dart';
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

    const MethodChannel('plugins.flutter.io/firebase_ml_vision').setMockMethodCallHandler((MethodCall methodCall) async {
      print('xxx - ${methodCall.method}');
      if (methodCall.method == 'TextRecognizer#processImage') {
        return {};
      }
      return null;
    });
  }

  Image getImageFromFile(File file) {
    return decodeImage(file.readAsBytesSync());
  }

  Future<Image> getCroppedImageFromFilePath(String path) async {
    File imageFile = await cameraState.getImageFileFromAssets(path);
    File imageFileCropped = await cameraState.cropPictureToSudokuSize(imageFile);
    return getImageFromFile(imageFileCropped);
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

    group('getImageFileFromAssets()', () {
      test('returns a file when a valid path is used', () async {
        File imageFileThatExists = await cameraState.getImageFileFromAssets('mock_sudoku.png');
        expect(imageFileThatExists, isNotNull);
      });

      test('returns null when an invalid path is used', () async {
        File imageFileThatDoesNotExist = await cameraState.getImageFileFromAssets('path_to_nowhere.png');
        expect(imageFileThatDoesNotExist, null);
      });

      test('works for smaller images', () async {
        File smallImageFile = await cameraState.getImageFileFromAssets('mock_sudoku_smaller.png');
        expect(smallImageFile, isNotNull);
      });

      test('works for lower resolution images', () async {
        File lowResImageFile = await cameraState.getImageFileFromAssets('mock_sudoku_low_res.png');
        expect(lowResImageFile, isNotNull);
      });

      test('works for .jpg images', () async {
        File jpgImageFile = await cameraState.getImageFileFromAssets('mock_sudoku.jpg');
        expect(jpgImageFile, isNotNull);
      });

      test('when converted to an image, it has the expected dimensions', () async {
        File largeImageFile = await cameraState.getImageFileFromAssets('mock_sudoku.png');
        Image largeImage = getImageFromFile(largeImageFile);

        expect(largeImage.width, 1080);
        expect(largeImage.height, 2168);
      });
    });

    group('cropPictureToSudokuSize()', () {
      File largeImageFile;

      setUp(() async {
        largeImageFile = await cameraState.getImageFileFromAssets('mock_sudoku.png');
        MyValues.screenWidth = 411;
        MyValues.cameraWidth = 347;
      });

      test('cropped image file is not null', () async {
        File smallImageFile = await cameraState.cropPictureToSudokuSize(largeImageFile);
        expect(smallImageFile, isNotNull);
      });

      test('cropped image file is at a different location to the full image file', () async {
        File smallImageFile = await cameraState.cropPictureToSudokuSize(largeImageFile);
        expect(largeImageFile.path != smallImageFile.path, true);
      });

      test('cropped image file is smaller than the full image file', () async {
        File smallImageFile = await cameraState.cropPictureToSudokuSize(largeImageFile);
        int largeImageFileLength = await largeImageFile.length();
        int smallImageFileLength = await smallImageFile.length();

        expect(largeImageFileLength > smallImageFileLength, true);
      });

      test('when converted to an image, the cropped image is smaller', () async {
        File smallImageFile = await cameraState.cropPictureToSudokuSize(largeImageFile);
        Image largeImage = getImageFromFile(largeImageFile);
        Image smallImage = getImageFromFile(smallImageFile);

        expect(largeImage.width > smallImage.width, true);
        expect(largeImage.height > smallImage.height, true);
      });

      test('when converted to an image, height and width are the same', () async {
        File smallImageFile = await cameraState.cropPictureToSudokuSize(largeImageFile);
        Image smallImage = getImageFromFile(smallImageFile);

        expect(smallImage.height, smallImage.height);
      });

      group('when converted to an image, it has the expected dimensions', () {
        test('for a standard image', () async {
          Image largeImageCropped = await getCroppedImageFromFilePath('mock_sudoku.png');

          expect(largeImageCropped.width, 912);
          expect(largeImageCropped.height, 912);
        });

        test('for a smaller image', () async {
          Image smallImageCropped = await getCroppedImageFromFilePath('mock_sudoku_smaller.png');

          expect(smallImageCropped.width, 422);
          expect(smallImageCropped.height, 422);
        });

        test('for a low res image', () async {
          Image lowResImageCropped = await getCroppedImageFromFilePath('mock_sudoku_low_res.png');

          expect(lowResImageCropped.width, 912);
          expect(lowResImageCropped.height, 912);
        });

        test('for a jpg image', () async {
          Image jpgImageCropped = await getCroppedImageFromFilePath('mock_sudoku.jpg');

          expect(jpgImageCropped.width, 912);
          expect(jpgImageCropped.height, 912);
        });
      });
    });

    // group('getImageFileFromAssets()', () {
    //   test('for a jpg image', () async {
    //     File imageFileThatExists = await cameraState.getImageFileFromAssets('mock_sudoku.png');

    //     final FirebaseVisionImage _firebaseVisionImage = FirebaseVisionImage.fromFile(imageFileThatExists);
    //     final TextRecognizer _textRecognizer = FirebaseVision.instance.textRecognizer();
    //     final VisionText _visionText = await _textRecognizer.processImage(_firebaseVisionImage);
    //     cameraState.getTextElementsFromVisionText(_visionText);
    //   });
    // });
  });
}
