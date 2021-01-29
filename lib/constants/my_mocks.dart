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
      return null;
  }
}

Future<File> _getImageFileFromAssets(String path) async {
  ByteData byteData;
  try {
    byteData = await rootBundle.load('assets/$path');
  } on Exception catch (e) {
    await logError('ERROR: no file found at assets/$path', e);
    return null;
  }
  final File file = File('${(await getApplicationDocumentsDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

Future<void> _setVeryHighResPictureMock() async {
  const MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'takePicture') {
      final String imagePath = methodCall.arguments['path'];
      final File mockFile = await File(imagePath).create();
      final File mockImageFile = await _getImageFileFromAssets('sudoku_photo_2160x3840.png');
      mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
    }
    return null;
  });
}

Future<void> _setHighResPictureMock() async {
  const MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'takePicture') {
      final String imagePath = methodCall.arguments['path'];
      final File mockFile = await File(imagePath).create();
      final File mockImageFile = await _getImageFileFromAssets('sudoku_photo_1080x1920.png');
      mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
    }
    return null;
  });
}

Future<void> _setMediumResPictureMock() async {
  const MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'takePicture') {
      final String imagePath = methodCall.arguments['path'];
      final File mockFile = await File(imagePath).create();
      final File mockImageFile = await _getImageFileFromAssets('sudoku_photo_720x1280.png');
      mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
    }
    return null;
  });
}

Future<void> _setTimeoutErrorPictureMock() async {
  const MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'takePicture') {
      final String imagePath = methodCall.arguments['path'];
      final File mockFile = await File(imagePath).create();
      final File mockImageFile = await _getImageFileFromAssets('sudoku_photo_that_causes_timeout_error.png');
      mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
    }
    return null;
  });
}

Future<void> _setInvalidErrorPictureMock() async {
  const MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'takePicture') {
      final String imagePath = methodCall.arguments['path'];
      final File mockFile = await File(imagePath).create();
      final File mockImageFile = await _getImageFileFromAssets('sudoku_photo_that_causes_invalid_error.png');
      mockFile.writeAsBytesSync(mockImageFile.readAsBytesSync());
    }
    return null;
  });
}

Future<void> _deleteAllMocks() async {
  const MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler(null);
  const MethodChannel('plugins.flutter.io/firebase_ml_vision').setMockMethodCallHandler(null);
}

Future<void> _setCameraNotFoundErrorMock() async {
  const MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
    throw CameraException('mock camera exception', 'yeee');
  });
}

Future<void> _setPhotoProcessingErrorMock() async {
  const MethodChannel('plugins.flutter.io/firebase_ml_vision').setMockMethodCallHandler((MethodCall methodCall) async {
    throw Exception('mock firebase exception');
  });
}
