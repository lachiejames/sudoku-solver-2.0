import 'dart:collection';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

class MyWidgets {
  static Widget getEmptyWidget() {
    return Container();
  }

  static Widget makeProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: MyColors.green,
      ),
    );
  }

  static Widget makeButtonText(String text) {
    return Text(
      text,
      style: MyStyles.buttonTextStyle,
      textDirection: TextDirection.ltr,
    );
  }

  static Widget makeText(String text) {
    return Text(
      text,
      style: MyStyles.appBarTextStyle,
      textDirection: TextDirection.ltr,
    );
  }

  static Widget makeAppBar(String appBarText) {
    return AppBar(
      iconTheme: IconThemeData(color: MyColors.white),
      title: Text(
        appBarText,
        textAlign: TextAlign.left,
        style: MyStyles.appBarTextStyle,
        textDirection: TextDirection.ltr,
      ),
    );
  }

  static Widget makeTopText(String text, Color color) {
    return Container(
      alignment: Alignment.center,
      padding: MyStyles.topTextMargins,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: MyValues.topTextFontSize,
          color: color,
        ),
        textDirection: TextDirection.ltr,
      ),
    );
  }

  static Widget makeHowToText(String text) {
    return Container(
      margin: MyStyles.topTextMargins,
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: MyStyles.howToTextStyle,
        textDirection: TextDirection.ltr,
      ),
    );
  }

  static HashMap<TileKey, TileState> initTileStateMap() {
    HashMap<TileKey, TileState> _tileStateMap = HashMap<TileKey, TileState>();
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        _tileStateMap[TileKey(row: row, col: col)] = TileState(row: row, col: col);
      }
    }
    return _tileStateMap;
  }

  static List<NumberState> initNumberStateList() {
    List<NumberState> _numberStateList = List<NumberState>();
    for (int n = 1; n <= 9; n++) {
      _numberStateList.add(NumberState(number: n));
    }
    return _numberStateList;
  }

  static TileKey extractSelectedTileKey(HashMap<TileKey, TileState> tileStateMap) {
    for (MapEntry<TileKey, TileState> entry in tileStateMap.entries) {
      if (entry.value.isSelected) {
        return entry.key;
      }
    }
    return null;
  }

  static List<TileKey> makeTileKeysFromRowsAndCols(List<int> rows, List<int> cols) {
    List<TileKey> _tileKeys = List<TileKey>();
    for (int row in rows) {
      for (int col in cols) {
        _tileKeys.add(TileKey(row: row, col: col));
      }
    }
    return _tileKeys;
  }

  static List<TileKey> getTileKeysInSegment(int segment) {
    List<TileKey> _tileKeys = List<TileKey>();

    if (segment == 1) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols([1, 2, 3], [1, 2, 3]));
    } else if (segment == 2) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols([1, 2, 3], [4, 5, 6]));
    } else if (segment == 3) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols([1, 2, 3], [7, 8, 9]));
    } else if (segment == 4) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols([4, 5, 6], [1, 2, 3]));
    } else if (segment == 5) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols([4, 5, 6], [4, 5, 6]));
    } else if (segment == 6) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols([4, 5, 6], [7, 8, 9]));
    } else if (segment == 7) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols([7, 8, 9], [1, 2, 3]));
    } else if (segment == 8) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols([7, 8, 9], [4, 5, 6]));
    } else {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols([7, 8, 9], [7, 8, 9]));
    }
    return _tileKeys;
  }

  static Future<CameraState> initCamera() async {
    CameraDescription cameraDescription;
    CameraController cameraController;
    try {
      cameraDescription = (await availableCameras())[0];
      cameraController = CameraController(cameraDescription, ResolutionPreset.low);
      await cameraController.initialize();
    } catch (e) {
      print(e);
    }

    return CameraState(
      cameraDescription: cameraDescription,
      cameraController: cameraController,
    );
  }
}
