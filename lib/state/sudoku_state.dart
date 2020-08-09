import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

@immutable
class SudokuState {
  final HashMap<TileKey, TileState> tileStateMap;

  SudokuState({this.tileStateMap});

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

  void replaceTile(TileState newTileState) {
    this.tileStateMap[TileKey(row: newTileState.row, col: newTileState.col)] = newTileState;
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
  }

  SudokuState copyWith({TileState tileState}) {
    SudokuState nextSudokuState = SudokuState();
    nextSudokuState.tileStateMap[TileKey(row: tileState.row, col: tileState.col)] = tileState;
    return nextSudokuState;
  }
}
