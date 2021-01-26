part of './constants.dart';

String imagePath;

Future<File> _getImageFileFromAssets(String path) async {
  ByteData byteData;
  try {
    byteData = await rootBundle.load('assets/$path');
  } on Exception catch (e) {
    logError('ERROR: no file found at assets/$path', e);
    return null;
  }
  File file = await File('${(await getApplicationDocumentsDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

void setVeryHighResPictureMock() async {
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

void setHighResPictureMock() async {
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

void setMediumResPictureMock() async {
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

void setTimeoutErrorPictureMock() async {
  await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'takePicture') {
      imagePath = methodCall.arguments['path'];
      File mockFile = await File(imagePath).create();
      File mockImageFile = await _getImageFileFromAssets('sudoku_photo_that_causes_timeout_error.png');
      mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
    }
    return Future.value();
  });
}

void setInvalidErrorPictureMock() async {
  await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'takePicture') {
      imagePath = methodCall.arguments['path'];
      File mockFile = await File(imagePath).create();
      File mockImageFile = await _getImageFileFromAssets('sudoku_photo_that_causes_invalid_error.png');
      mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
    }
    return Future.value();
  });
}

void deleteAllMocks() async {
  await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler(null);
  await MethodChannel('plugins.flutter.io/firebase_ml_vision').setMockMethodCallHandler(null);
}

void setCameraNotFoundErrorMock() async {
  await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    throw CameraException('mock camera exception', 'yeee');
  });
}

void setPhotoProcessingErrorMock() async {
  await MethodChannel('plugins.flutter.io/firebase_ml_vision').setMockMethodCallHandler((MethodCall methodCall) async {
    throw Exception('mock firebase exception');
  });
}
