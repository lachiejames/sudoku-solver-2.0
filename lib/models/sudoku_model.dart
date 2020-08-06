import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:sudoku_solver_2/models/tile_key.dart';
import 'package:sudoku_solver_2/models/tile_model.dart';

class SudokuModel extends ChangeNotifier {
  HashMap<TileKey, TileModel> tileModelMap;

  SudokuModel() {
    this.tileModelMap = this.initTileModelMap();
  }

  String toString() {
    String s = '-------------------------------------\n';
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        if (this.getTileModelAt(row, col).value == null) {
          s += '|   ';
        } else {
          s += '| ' + this.getTileModelAt(row, col).value.toString() + ' ';
        }
      }
      s += '|\n-------------------------------------\n';
    }

    return s;
  }

  HashMap<TileKey, TileModel> initTileModelMap() {
    HashMap<TileKey, TileModel> _tileModelMap = HashMap<TileKey, TileModel>();
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        _tileModelMap[TileKey(row: row, col: col)] = TileModel(row: row, col: col);
      }
    }
    return _tileModelMap;
  }

  TileModel getTileModelAt(int row, int col) {
    return tileModelMap[TileKey(row: row, col: col)];
  }

  void applyExampleValues(List<List<int>> exampleValues) {
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        int nextValue = exampleValues[row - 1][col - 1];
        TileModel nextTile = this.getTileModelAt(row, col);
        this.addValueToTile(nextValue, nextTile);
      }
    }
  }

  void addValueToTile(int value, TileModel tileModel) {
    tileModel.setValue(value);
  }
}
