import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class MyMockHelper {
  static Future<File> getImageFileFromAssets(String path) async {
    ByteData byteData;
    try {
      byteData = await rootBundle.load('assets/$path');
    } on Exception catch (e) {
      print('ERROR: no file found at assets/$path');
      print(e);
      return null;
    }
    final file = File('${(await getApplicationDocumentsDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  static void takePicture() {
    const MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'takePicture') {
        String imagePath = methodCall.arguments['path'];
        File mockFile = await File(imagePath).create();
        File mockImageFile = await getImageFileFromAssets('mock_sudoku.png');
        mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
      }
    });
  }
}
