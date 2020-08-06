import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:sudoku_solver_2/models/tile_key.dart';
import 'package:sudoku_solver_2/models/tile_model.dart';

class SudokuModel extends ChangeNotifier {
  HashMap<TileKey, TileModel> tileMap;

  SudokuModel() {
    this.tileMap = this.initTileMap();
  }

  String toString() {
    String s = '-------------------------------------\n';
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        if (this.getTileAt(row, col).value == null) {
          s += '|   ';
        } else {
          s += '| ' + this.getTileAt(row, col).value.toString() + ' ';
        }
      }
      s += '|\n-------------------------------------\n';
    }

    return s;
  }

  HashMap<TileKey, TileModel> initTileMap() {
    HashMap<TileKey, TileModel> _tileMap = HashMap<TileKey, TileModel>();
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        _tileMap[TileKey(row: row, col: col)] = TileModel(row: row, col: col);
      }
    }
    return _tileMap;
  }

  TileModel getTileAt(int row, int col) {
    return tileMap[TileKey(row: row, col: col)];
  }

  void applyExampleValues(List<List<int>> exampleValues) {
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        int nextValue = exampleValues[row - 1][col - 1];
        TileModel nextTile = this.getTileAt(row, col);
        this.addValueToTile(nextValue, nextTile);
      }
    }
  }

  void addValueToTile(int value, TileModel tile) {
    tile.setValue(value);
  }
}
