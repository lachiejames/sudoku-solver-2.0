import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

/// Used when solving the sudoku
/// Mutable for more efficient caclulations
class Sudoku {
  /// Store TileKey and Tile pairs, for all 81 tiles on a Sudoku
  final HashMap<TileKey, TileState> tileStateMap;

  /// Tracks how many tiles contain values
  /// Mutable for more efficient caclulations
  int numValues = 0;

  /// Initialises with the current number of values in the hashmap
  Sudoku({@required this.tileStateMap}) {
    this.numValues = initNumValues(this.tileStateMap.values.toList());
  }

  /// Returns the amount of tiles that have a value
  int initNumValues(List<TileState> tileStates) {
    int _numValues = 0;
    for (TileState tileState in tileStates) {
      if (tileState.value != null) {
        _numValues++;
      }
    }
    return _numValues;
  }

  @override
  String toString() {
    String s = '-------------------------------------\n';
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        if (this.getTileStateAt(row, col).value == null) {
          s += '|   ';
        } else {
          s += '| ${this.getTileStateAt(row, col).value} ';
        }
      }
      s += '|\n-------------------------------------\n';
    }

    return s;
  }

  /// Returns the tile at the given row & column
  TileState getTileStateAt(int row, int col) {
    return this.tileStateMap[TileKey(row: row, col: col)];
  }

  /// Applies the values specified in a hard-coded Sudoku
  void applyExampleValues(List<List<int>> exampleValues) {
    assert(exampleValues != null);
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        int nextValue = exampleValues[row - 1][col - 1];
        TileState nextTile = this.getTileStateAt(row, col);
        this.addValueToTile(nextValue, nextTile);
      }
    }
  }

  /// Assigns a given value to a given tile
  void addValueToTile(int value, TileState tileState) {
    // if tile already has a value, that is not this value
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

  /// Returns all tiles in the given row
  List<TileState> getTilesInRow(int row) {
    List<TileState> _tilesInRow = <TileState>[];
    for (int col = 1; col <= 9; col++) {
      _tilesInRow.add(this.getTileStateAt(row, col));
    }
    return _tilesInRow;
  }

  /// Returns all tiles in the given column
  List<TileState> getTilesInCol(int col) {
    List<TileState> _tilesInCol = <TileState>[];
    for (int row = 1; row <= 9; row++) {
      _tilesInCol.add(this.getTileStateAt(row, col));
    }
    return _tilesInCol;
  }

  /// Returns all tiles in the given segment
  List<TileState> getTilesInSegment(int segment) {
    List<TileState> _tilesInSegment = <TileState>[];
    for (TileKey tileKey in TileKey.getTileKeysInSegment(segment)) {
      _tilesInSegment.add(this.tileStateMap[tileKey]);
    }
    return _tilesInSegment;
  }

  /// Returns all values on the tiles in the given row
  List<int> getValuesInRow(int row) {
    List<int> _valuesInRow = <int>[];
    for (int col = 1; col <= 9; col++) {
      int value = this.getTileStateAt(row, col).value;
      if (value != null) {
        _valuesInRow.add(value);
      }
    }
    return _valuesInRow;
  }

  /// Returns all values on the tiles in the given column
  List<int> getValuesInCol(int col) {
    List<int> _valuesInCol = <int>[];
    for (int row = 1; row <= 9; row++) {
      int value = this.getTileStateAt(row, col).value;
      if (value != null) {
        _valuesInCol.add(value);
      }
    }
    return _valuesInCol;
  }

  /// Returns all values on the tiles in the given segment
  List<int> getValuesInSegment(int segment) {
    List<int> _valuesInSegment = <int>[];
    for (TileKey tileKey in TileKey.getTileKeysInSegment(segment)) {
      int value = this.tileStateMap[tileKey].value;
      if (value != null) {
        _valuesInSegment.add(value);
      }
    }
    return _valuesInSegment;
  }

  /// Returns all list of values that could be added to the given tile without
  /// violating constraints
  List<int> getPossibleValuesAtTile(TileState tile) {
    if (tile.value != null) {
      return [];
    }
    List<int> possibleValues = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    Set<int> invalidValues = <int>{};
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

  /// Contains only unique values in all rows, columns, and segments
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

  /// Every tile has a value
  bool isFull() {
    assert(0 <= this.numValues && this.numValues <= 81);
    return this.numValues == 81;
  }

  /// Returns a tile without a value if one exists
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

  /// Returns tile positions where the tile is violating a constaint
  List<TileKey> getInvalidTileKeys() {
    List<TileState> invalidTiles = <TileState>[];
    for (int i = 1; i <= 9; i++) {
      List<int> valuesInRow = getValuesInRow(i);
      List<int> valuesInCol = getValuesInCol(i);
      List<int> valuesInSeg = getValuesInSegment(i);

      List<int> uniqueValuesInRow = valuesInRow.toSet().toList();
      List<int> uniqueValuesInCol = valuesInCol.toSet().toList();
      List<int> uniqueValuesInSeg = valuesInSeg.toSet().toList();

      for (int n in uniqueValuesInRow) {
        valuesInRow.remove(n);
      }
      for (int n in uniqueValuesInCol) {
        valuesInCol.remove(n);
      }
      for (int n in uniqueValuesInSeg) {
        valuesInSeg.remove(n);
      }

      // Get the tiles in the row that have this duplicateValue
      List<TileState> tilesInRow = getTilesInRow(i);
      for (TileState tile in tilesInRow) {
        if (valuesInRow.contains(tile.value)) {
          invalidTiles.add(tile);
        }
      }
      List<TileState> tilesInCol = getTilesInCol(i);
      for (TileState tile in tilesInCol) {
        if (valuesInCol.contains(tile.value)) {
          invalidTiles.add(tile);
        }
      }
      List<TileState> tilesInSeg = getTilesInSegment(i);
      for (TileState tile in tilesInSeg) {
        if (valuesInSeg.contains(tile.value)) {
          invalidTiles.add(tile);
        }
      }
    }
    invalidTiles = invalidTiles.toSet().toList();

    List<TileKey> invalidTileKeys = <TileKey>[];
    for (TileState tile in invalidTiles) {
      invalidTileKeys.add(TileKey(row: tile.row, col: tile.col));
    }

    // Make it unique
    return invalidTileKeys;
  }
}
