import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/services.dart';

import 'my_solved_games.dart' as my_solved_games;

class TestConstants {
  static final List<String> solvedGames = my_solved_games.solvedGames;

  static final String emptySudokuString = '''
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
''';

  static final String game1ValuesListString = '''
-------------------------------------
|   |   |   | 5 | 4 | 3 | 9 |   |   |
-------------------------------------
|   |   | 7 |   |   |   |   |   |   |
-------------------------------------
|   |   |   | 6 |   |   |   | 3 |   |
-------------------------------------
|   |   |   |   |   |   |   |   | 6 |
-------------------------------------
|   |   | 8 | 9 |   |   |   |   |   |
-------------------------------------
|   |   | 9 |   | 8 | 4 |   |   |   |
-------------------------------------
|   | 7 |   |   |   |   |   |   | 4 |
-------------------------------------
|   | 3 |   |   |   | 6 |   | 2 |   |
-------------------------------------
| 2 |   | 4 |   | 1 |   |   | 7 |   |
-------------------------------------
''';

  static final List<List<int>> game2ValuesListSolved = [
    [8, 2, 1, 4, 9, 7, 3, 5, 6],
    [6, 9, 5, 1, 3, 2, 7, 4, 8],
    [3, 4, 7, 6, 5, 8, 9, 2, 1],
    [4, 7, 9, 2, 6, 3, 1, 8, 5],
    [2, 1, 8, 9, 7, 5, 4, 6, 3],
    [5, 3, 6, 8, 4, 1, 2, 7, 9],
    [1, 5, 3, 7, 2, 6, 8, 9, 4],
    [7, 8, 4, 5, 1, 9, 6, 3, 2],
    [9, 6, 2, 3, 8, 4, 5, 1, 7],
  ];

  static final String game1TilesInRow1String =
      '[TileState(row=1, col=1, value=null, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=1, col=2, value=null, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=1, col=3, value=null, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=1, col=4, value=5, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=1, col=5, value=4, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=1, col=6, value=3, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=1, col=7, value=9, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=1, col=8, value=null, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=1, col=9, value=null, isSelected=false, isOriginalTile=false, isinvalid=false)]';

  static final String game1TilesInCol3String =
      '[TileState(row=1, col=3, value=null, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=2, col=3, value=7, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=3, col=3, value=null, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=4, col=3, value=null, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=5, col=3, value=8, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=6, col=3, value=9, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=7, col=3, value=null, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=8, col=3, value=null, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=9, col=3, value=4, isSelected=false, isOriginalTile=false, isinvalid=false)]';
  static final String game1TilesInSegment2String =
      '[TileState(row=1, col=4, value=5, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=1, col=5, value=4, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=1, col=6, value=3, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=2, col=4, value=null, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=2, col=5, value=null, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=2, col=6, value=null, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=3, col=4, value=6, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=3, col=5, value=null, isSelected=false, isOriginalTile=false, isinvalid=false), TileState(row=3, col=6, value=null, isSelected=false, isOriginalTile=false, isinvalid=false)]';

  static final List<TextElement> game1TextElements = [
    MockTextElement('9', Rect.fromLTRB(137.0, 553.0, 194.0, 601.0)),
    MockTextElement('8', Rect.fromLTRB(224.0, 552.0, 248.0, 588.0)),
    MockTextElement('1', Rect.fromLTRB(264.0, 480.0, 308.0, 533.0)),
    MockTextElement('9', Rect.fromLTRB(338.0, 481.0, 375.0, 534.0)),
    MockTextElement('5', Rect.fromLTRB(392.0, 481.0, 438.0, 534.0)),
    MockTextElement('6', Rect.fromLTRB(516.0, 544.0, 563.0, 593.0)),
    MockTextElement('3', Rect.fromLTRB(603.0, 612.0, 634.0, 663.0)),
    MockTextElement('6', Rect.fromLTRB(330.0, 612.0, 374.0, 650.0)),
    MockTextElement('2', Rect.fromLTRB(329.0, 731.0, 373.0, 783.0)),
    MockTextElement('2', Rect.fromLTRB(438.0, 793.0, 502.0, 851.0)),
    MockTextElement('8', Rect.fromLTRB(529.0, 792.0, 569.0, 849.0)),
    MockTextElement('1', Rect.fromLTRB(354.0, 864.0, 373.0, 902.0)),
    MockTextElement('9', Rect.fromLTRB(401.0, 859.0, 446.0, 913.0)),
    MockTextElement('8', Rect.fromLTRB(327.0, 918.0, 379.0, 978.0)),
    MockTextElement('6', Rect.fromLTRB(133.0, 792.0, 185.0, 848.0)),
    MockTextElement('5', Rect.fromLTRB(591.0, 856.0, 652.0, 915.0)),
    MockTextElement('7', Rect.fromLTRB(503.0, 919.0, 576.0, 977.0)),
    MockTextElement('9', Rect.fromLTRB(594.0, 918.0, 634.0, 975.0)),
  ];

  static String _tempDirectory;
  static Future<String> getTempDirectory() async {
    if (_tempDirectory == null) {
      final Directory directory = await Directory.systemTemp.createTemp();
      _tempDirectory = directory.path;
    }
    return _tempDirectory;
  }

  static List<File> createdFiles = [];

  static Future<void> deleteCreatedFiles() async {
    for (File file in TestConstants.createdFiles) {
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
    TestConstants.createdFiles.clear();
  }

  static Future<File> getImageFileFromAssets(String path) async {
    ByteData byteData;
    try {
      byteData = await rootBundle.load('assets/$path');
    } on Exception catch (e) {
      print('ERROR: no file found at assets/$path\n $e');
      return null;
    }
    File file = await File('${Random().nextDouble()}_$path').create();
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    createdFiles.add(file);
    return file;
  }

  static CameraController getMockCameraController() {
    return CameraController(
      CameraDescription(
        name: "mock",
        lensDirection: CameraLensDirection.front,
        sensorOrientation: 0,
      ),
      ResolutionPreset.max,
    );
  }
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
