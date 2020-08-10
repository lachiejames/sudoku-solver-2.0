import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

@immutable
class SudokuState {
  final HashMap<TileKey, TileState> tileStateMap;

  SudokuState({@required this.tileStateMap});

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
    tileState = tileState.copyWith(value: value);
    TileKey tileKey = TileKey(row: tileState.row, col: tileState.col);
    this.tileStateMap[tileKey] = tileState;
  }

  List<TileState> getTilesInRow(int row) {
    List<TileState> _tilesInRow = List<TileState>();
    for (int col = 1; col <= 9; col++) {
      _tilesInRow.add(this.getTileStateAt(row, col));
    }
    return _tilesInRow;
  }

  List<TileState> getTilesInCol(int col) {
    List<TileState> _tilesInCol = List<TileState>();
    for (int row = 1; row <= 9; row++) {
      _tilesInCol.add(this.getTileStateAt(row, col));
    }
    return _tilesInCol;
  }

  List<TileState> getTilesInSegment(int segment) {
    List<TileState> _tilesInSegment = List<TileState>();
    for (TileKey tileKey in MyWidgets.getTileKeysInSegment(segment)) {
      _tilesInSegment.add(tileStateMap[tileKey]);
    }
    return _tilesInSegment;
  }

  SudokuState copyWith({HashMap<TileKey, TileState> tileStateMap}) {
    return SudokuState(
      tileStateMap: tileStateMap,
    );
  }
}
