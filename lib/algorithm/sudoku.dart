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
    numValues = initNumValues(tileStateMap.values.toList());
  }

  /// Returns the amount of tiles that have a value
  int initNumValues(List<TileState> tileStates) {
    int _numValues = 0;
    for (final TileState tileState in tileStates) {
      if (tileState.value != null) {
        _numValues++;
      }
    }
    return _numValues;
  }

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer()..write('-------------------------------------\n');
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        if (getTileStateAt(row, col).value == null) {
          buffer.write('|   ');
        } else {
          buffer.write('| ${getTileStateAt(row, col).value} ');
        }
      }
      buffer.write('|\n-------------------------------------\n');
    }

    return buffer.toString();
  }

  /// Returns the tile at the given row & column
  TileState getTileStateAt(int row, int col) => tileStateMap[TileKey(row: row, col: col)];

  /// Applies the values specified in a hard-coded Sudoku
  void applyExampleValues(List<List<int>> exampleValues) {
    assert(exampleValues != null);
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        final int nextValue = exampleValues[row - 1][col - 1];
        final TileState nextTile = getTileStateAt(row, col);
        addValueToTile(nextValue, nextTile);
      }
    }
  }

  /// Assigns a given value to a given tile
  void addValueToTile(int value, TileState tileState) {
    assert(tileState != null);
    // if tile already has a value, that is not this value
    if ((tileState.value == null && value == null) || (tileState.value != null && value != null)) {
      tileState.value = value;
      return;
    }

    // removing a value from this tile
    if (value == null) {
      numValues--;
    } else {
      // adding a value to this tile, when it did not previously have one
      numValues++;
    }
    assert(0 <= numValues && numValues <= 81);

    tileState.value = value;
  }

  /// Returns all tiles in the given row
  List<TileState> getTilesInRow(int row) {
    final List<TileState> _tilesInRow = <TileState>[];
    for (int col = 1; col <= 9; col++) {
      _tilesInRow.add(getTileStateAt(row, col));
    }
    return _tilesInRow;
  }

  /// Returns all tiles in the given column
  List<TileState> getTilesInCol(int col) {
    final List<TileState> _tilesInCol = <TileState>[];
    for (int row = 1; row <= 9; row++) {
      _tilesInCol.add(getTileStateAt(row, col));
    }
    return _tilesInCol;
  }

  /// Returns all tiles in the given segment
  List<TileState> getTilesInSegment(int segment) {
    final List<TileState> _tilesInSegment = <TileState>[];
    for (final TileKey tileKey in TileKey.getTileKeysInSegment(segment)) {
      _tilesInSegment.add(tileStateMap[tileKey]);
    }
    return _tilesInSegment;
  }

  /// Returns all values on the tiles in the given row
  List<int> getValuesInRow(int row) {
    final List<int> _valuesInRow = <int>[];
    for (int col = 1; col <= 9; col++) {
      final int value = getTileStateAt(row, col).value;
      if (value != null) {
        _valuesInRow.add(value);
      }
    }
    return _valuesInRow;
  }

  /// Returns all values on the tiles in the given column
  List<int> getValuesInCol(int col) {
    final List<int> _valuesInCol = <int>[];
    for (int row = 1; row <= 9; row++) {
      final int value = getTileStateAt(row, col).value;
      if (value != null) {
        _valuesInCol.add(value);
      }
    }
    return _valuesInCol;
  }

  /// Returns all values on the tiles in the given segment
  List<int> getValuesInSegment(int segment) {
    final List<int> _valuesInSegment = <int>[];
    for (final TileKey tileKey in TileKey.getTileKeysInSegment(segment)) {
      final int value = tileStateMap[tileKey].value;
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
      return <int>[];
    }
    final List<int> possibleValues = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9];
    final Set<int> invalidValues = <int>{};
    getValuesInRow(tile.row).forEach(invalidValues.add);
    getValuesInCol(tile.col).forEach(invalidValues.add);
    getValuesInSegment(tile.getSegment()).forEach(invalidValues.add);
    invalidValues.forEach(possibleValues.remove);

    return possibleValues;
  }

  /// Contains only unique values in all rows, columns, and segments
  bool allConstraintsSatisfied() {
    for (int i = 1; i <= 9; i++) {
      final List<int> valuesInRow = getValuesInRow(i);
      final List<int> valuesInCol = getValuesInCol(i);
      final List<int> valuesInSegment = getValuesInSegment(i);

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
    assert(0 <= numValues && numValues <= 81);
    return numValues == 81;
  }

  /// Returns a tile without a value if one exists
  TileState getNextTileWithoutValue() {
    if (isFull()) {
      return null;
    }

    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        final TileState _tileState = getTileStateAt(row, col);
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
      final List<int> valuesInRow = getValuesInRow(i);
      final List<int> valuesInCol = getValuesInCol(i);
      final List<int> valuesInSeg = getValuesInSegment(i);

      final List<int> uniqueValuesInRow = valuesInRow.toSet().toList();
      final List<int> uniqueValuesInCol = valuesInCol.toSet().toList();
      final List<int> uniqueValuesInSeg = valuesInSeg.toSet().toList();
      uniqueValuesInRow.forEach(valuesInRow.remove);
      uniqueValuesInCol.forEach(valuesInCol.remove);
      uniqueValuesInSeg.forEach(valuesInSeg.remove);

      // Get the tiles in the row that have this duplicateValue
      final List<TileState> tilesInRow = getTilesInRow(i);
      for (final TileState tile in tilesInRow) {
        if (valuesInRow.contains(tile.value)) {
          invalidTiles.add(tile);
        }
      }
      final List<TileState> tilesInCol = getTilesInCol(i);
      for (final TileState tile in tilesInCol) {
        if (valuesInCol.contains(tile.value)) {
          invalidTiles.add(tile);
        }
      }
      final List<TileState> tilesInSeg = getTilesInSegment(i);
      for (final TileState tile in tilesInSeg) {
        if (valuesInSeg.contains(tile.value)) {
          invalidTiles.add(tile);
        }
      }
    }
    invalidTiles = invalidTiles.toSet().toList();

    final List<TileKey> invalidTileKeys = <TileKey>[];
    for (final TileState tile in invalidTiles) {
      invalidTileKeys.add(TileKey(row: tile.row, col: tile.col));
    }

    // Make it unique
    return invalidTileKeys;
  }
}
