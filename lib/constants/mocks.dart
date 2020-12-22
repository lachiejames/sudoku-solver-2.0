import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class MyMockHelper {
  static String imagePath;

  static Future<File> _getImageFileFromAssets(String path) async {
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

  static void setVeryHighResPictureMock() async {
    await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'takePicture') {
        imagePath = methodCall.arguments['path'];
        File mockFile = await File(imagePath).create();
        File mockImageFile = await _getImageFileFromAssets('sudoku_photo_2160x3840.png');
        mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
      }
      return Future.value();
    });
  }

  static void setHighResPictureMock() async {
    await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'takePicture') {
        imagePath = methodCall.arguments['path'];
        File mockFile = await File(imagePath).create();
        File mockImageFile = await _getImageFileFromAssets('sudoku_photo_1080x1920.png');
        mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
      }
      return Future.value();
    });
  }

  static void setMediumResPictureMock() async {
    await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'takePicture') {
        imagePath = methodCall.arguments['path'];
        File mockFile = await File(imagePath).create();
        File mockImageFile = await _getImageFileFromAssets('sudoku_photo_720x1280.png');
        mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
      }
      return Future.value();
    });
  }

  static void deletePictureMock() async {
    await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler(null);
  }
}
