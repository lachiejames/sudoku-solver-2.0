import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;

class MyMockHelper {
  static String imagePath;

  static Future<File> _getImageFileFromAssets(String path) async {
    ByteData byteData;
    try {
      byteData = await rootBundle.load('assets/$path');
    } on Exception catch (e) {
      print('ERROR: no file found at assets/$path');
      print(e);
      return null;
    }
    File file = await File('${(await getApplicationDocumentsDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  static Future<void> _deleteImageFileFromAssets(String path) async {
    await File('${(await getApplicationDocumentsDirectory()).path}/$path').delete();
  }

  static void setPictureMock() async {
    const MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'takePicture') {
        imagePath = methodCall.arguments['path'];
        File mockFile = await File(imagePath).create();
        File mockImageFile = await _getImageFileFromAssets('mock_sudoku.png');
        mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
      }
    });
  }

  static void deletePictureMock() async {
    await File(imagePath).delete();
    await _deleteImageFileFromAssets('mock_sudoku.png');
    await my_values.cameraController?.dispose();
  }
}
