import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

class Sudoku {
  final HashMap<TileKey, TileState> tileStateMap;
  int numValues = 0;

  Sudoku({@required this.tileStateMap}) {
    this.numValues = initNumValues(this.tileStateMap.values);
  }

  int initNumValues(List<TileState> tileStates) {
    int _numValues = 0;
    for (TileState tileState in tileStates) {
      if (tileState.value != null) {
        _numValues++;
      }
    }
    return _numValues;
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

  TileState getTileStateAt(int row, int col) {
    return this.tileStateMap[TileKey(row: row, col: col)];
  }

  void applyExampleValues(List<List<int>> exampleValues) {
    assert(exampleValues != null);
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        int nextValue = exampleValues[row - 1][col - 1];
        assert(nextValue != null);
        TileState nextTile = this.getTileStateAt(row, col);
        this.addValueToTile(nextValue, nextTile);
      }
    }
  }

  void addValueToTile(int value, TileState tileState) {
    // tile already has a value, that is not this value
    if ((tileState.value == null && value == null) || (tileState.value != null && value != null)) {
      tileState.value = value;
      return;
    }

    // removing a value from this tile
    if (value == null) {
      this.numValues--;
    } else {
      // adding a value to this tile, when it did not previously have one
      this.numValues++;
    }
    assert(0 <= this.numValues && this.numValues <= 81);

    tileState.value = value;
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
      _tilesInSegment.add(this.tileStateMap[tileKey]);
    }
    return _tilesInSegment;
  }

  List<int> getValuesInRow(int row) {
    List<int> _valuesInRow = List<int>();
    for (int col = 1; col <= 9; col++) {
      int value = this.getTileStateAt(row, col).value;
      if (value != null) {
        _valuesInRow.add(value);
      }
    }
    return _valuesInRow;
  }

  List<int> getValuesInCol(int col) {
    List<int> _valuesInCol = List<int>();
    for (int row = 1; row <= 9; row++) {
      int value = this.getTileStateAt(row, col).value;
      if (value != null) {
        _valuesInCol.add(value);
      }
    }
    return _valuesInCol;
  }

  List<int> getValuesInSegment(int segment) {
    List<int> _valuesInSegment = List<int>();
    for (TileKey tileKey in MyWidgets.getTileKeysInSegment(segment)) {
      int value = this.tileStateMap[tileKey].value;
      if (value != null) {
        _valuesInSegment.add(value);
      }
    }
    return _valuesInSegment;
  }

  List<int> getPossibleValuesAtTile(TileState tile) {
    if (tile.value != null) {
      return [];
    }
    List<int> possibleValues = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    Set<int> invalidValues = Set<int>();
    for (int invalidValue in getValuesInRow(tile.row)) {
      invalidValues.add(invalidValue);
    }
    for (int invalidValue in getValuesInCol(tile.col)) {
      invalidValues.add(invalidValue);
    }
    for (int invalidValue in getValuesInSegment(tile.getSegment())) {
      invalidValues.add(invalidValue);
    }

    for (int invalidValue in invalidValues) {
      possibleValues.remove(invalidValue);
    }

    return possibleValues;
  }

  bool allConstraintsSatisfied() {
    for (int i = 1; i <= 9; i++) {
      List<int> valuesInRow = getValuesInRow(i);
      List<int> valuesInCol = getValuesInCol(i);
      List<int> valuesInSegment = getValuesInSegment(i);

      if (valuesInRow.length != valuesInRow.toSet().length ||
          valuesInCol.length != valuesInCol.toSet().length ||
          valuesInSegment.length != valuesInSegment.toSet().length) {
        return false;
      }
    }
    return true;
  }

  bool isFull() {
    assert(0 <= this.numValues && this.numValues <= 81);
    return this.numValues == 81;
  }

  TileState getNextTileWithoutValue() {
    if (this.isFull()) {
      return null;
    }

    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        TileState _tileState = this.getTileStateAt(row, col);
        if (_tileState.value == null) {
          return _tileState;
        }
      }
    }
    return null;
  }
}
