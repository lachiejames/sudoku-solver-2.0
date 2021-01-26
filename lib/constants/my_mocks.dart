part of './constants.dart';

Future<dynamic> setMock(String mockName) async {
  switch (mockName) {
    case 'setVeryHighResPictureMock':
      return _setVeryHighResPictureMock();
    case 'setHighResPictureMock':
      return _setHighResPictureMock();
    case 'setMediumResPictureMock':
      return _setMediumResPictureMock();
    case 'deleteAllMocks':
      return _deleteAllMocks();
    case 'setCameraNotFoundErrorMock':
      return _setCameraNotFoundErrorMock();
    case 'setPhotoProcessingErrorMock':
      return _setPhotoProcessingErrorMock();
    case 'setTimeoutErrorPictureMock':
      return _setTimeoutErrorPictureMock();
    case 'setInvalidErrorPictureMock':
      return _setInvalidErrorPictureMock();
    default:
      print('ERROR: invalid mock name');
      return null;
  }
}

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

Future<void> _setVeryHighResPictureMock() async {
  await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'takePicture') {
      String imagePath = methodCall.arguments['path'];
      File mockFile = await File(imagePath).create();
      File mockImageFile = await _getImageFileFromAssets('sudoku_photo_2160x3840.png');
      mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
    }
    return Future.value();
  });
}

Future<void> _setHighResPictureMock() async {
  await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'takePicture') {
      String imagePath = methodCall.arguments['path'];
      File mockFile = await File(imagePath).create();
      File mockImageFile = await _getImageFileFromAssets('sudoku_photo_1080x1920.png');
      mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
    }
    return Future.value();
  });
}

Future<void> _setMediumResPictureMock() async {
  await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'takePicture') {
      String imagePath = methodCall.arguments['path'];
      File mockFile = await File(imagePath).create();
      File mockImageFile = await _getImageFileFromAssets('sudoku_photo_720x1280.png');
      mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
    }
    return Future.value();
  });
}

Future<void> _setTimeoutErrorPictureMock() async {
  await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'takePicture') {
      String imagePath = methodCall.arguments['path'];
      File mockFile = await File(imagePath).create();
      File mockImageFile = await _getImageFileFromAssets('sudoku_photo_that_causes_timeout_error.png');
      mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
    }
    return Future.value();
  });
}

Future<void> _setInvalidErrorPictureMock() async {
  await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'takePicture') {
      String imagePath = methodCall.arguments['path'];
      File mockFile = await File(imagePath).create();
      File mockImageFile = await _getImageFileFromAssets('sudoku_photo_that_causes_invalid_error.png');
      mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
    }
    return Future.value();
  });
}

Future<void> _deleteAllMocks() async {
  await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler(null);
  await MethodChannel('plugins.flutter.io/firebase_ml_vision').setMockMethodCallHandler(null);
}

Future<void> _setCameraNotFoundErrorMock() async {
  await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    throw CameraException('mock camera exception', 'yeee');
  });
}

Future<void> _setPhotoProcessingErrorMock() async {
  await MethodChannel('plugins.flutter.io/firebase_ml_vision').setMockMethodCallHandler((MethodCall methodCall) async {
    throw Exception('mock firebase exception');
  });
}
