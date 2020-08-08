import 'dart:collection';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

class SudokuState {
  HashMap<TileKey, TileState> tileStateMap;

  SudokuState() {
    this.tileStateMap = this.initTileStateMap();
  }

  String toString() {
    String s = '-------------------------------------\n';
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        if (this.getTileStateAt(row, col).value == null) {
          s += '|   ';
        } else {
          s += '| ' + this.getTileStateAt(row, col).value.toString() + ' ';
        }
      }
      s += '|\n-------------------------------------\n';
    }

    return s;
  }

  HashMap<TileKey, TileState> initTileStateMap() {
    HashMap<TileKey, TileState> _tileStateMap = HashMap<TileKey, TileState>();
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        _tileStateMap[TileKey(row: row, col: col)] = TileState(row: row, col: col);
      }
    }
    return _tileStateMap;
  }

  TileState getTileStateAt(int row, int col) {
    return tileStateMap[TileKey(row: row, col: col)];
  }

  void applyExampleValues(List<List<int>> exampleValues) {
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        int nextValue = exampleValues[row - 1][col - 1];
        TileState nextTile = this.getTileStateAt(row, col);
        this.addValueToTile(nextValue, nextTile);
      }
    }
  }

  void addValueToTile(int value, TileState tileState) {
    tileState.setValue(value);
  }
}
