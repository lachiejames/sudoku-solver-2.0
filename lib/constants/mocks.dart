import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';

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

  static void setPictureMock() async {
    await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'startImageStream') {
        dynamic mockData;

        cameraImage = CameraImage(mockData);
        // jsonEncode(cameraImage);
        // imagePath = methodCall.arguments['path'];
        // File mockFile = await File(imagePath).create();
        // File mockImageFile = await _getImageFileFromAssets('sudoku_screenshot.png');
        // mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
      }
      return Future.value();
    });
  }

  static void deletePictureMock() async {
    await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler(null);
  }
}
