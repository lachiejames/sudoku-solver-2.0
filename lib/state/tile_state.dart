import 'dart:collection';

import 'package:sudoku_solver_2/state/tile_key.dart';

class TileState {
  final int row;
  final int col;
  final bool isOriginalTile;

  int value;
  bool isSelected;
  bool isInvalid;

  TileState({
    this.row,
    this.col,
    this.value,
    this.isSelected = false,
    this.isOriginalTile = false,
    this.isInvalid = false,
  });

  String toString() {
    return 'TileState(row=$row, col=$col, value=${(value != null) ? value : 'null'}, isSelected=${this.isSelected})';
  }

  int getSegment() {
    if (1 <= row && row <= 3 && 1 <= col && col <= 3) {
      return 1;
    } else if (1 <= row && row <= 3 && 4 <= col && col <= 6) {
      return 2;
    } else if (1 <= row && row <= 3 && 7 <= col && col <= 9) {
      return 3;
    } else if (4 <= row && row <= 6 && 1 <= col && col <= 3) {
      return 4;
    } else if (4 <= row && row <= 6 && 4 <= col && col <= 6) {
      return 5;
    } else if (4 <= row && row <= 6 && 7 <= col && col <= 9) {
      return 6;
    } else if (7 <= row && row <= 9 && 1 <= col && col <= 3) {
      return 7;
    } else if (7 <= row && row <= 9 && 4 <= col && col <= 6) {
      return 8;
    } else {
      return 9;
    }
  }

  TileState copyWith({
    int value,
    bool isSelected,
    bool isOriginalTile,
    bool isInvalid,
  }) {
    return TileState(
      row: this.row,
      col: this.col,
      value: _decideValueToPass(value),
      isSelected: isSelected ?? this.isSelected,
      isOriginalTile: isOriginalTile ?? this.isOriginalTile,
      isInvalid: isInvalid ?? this.isInvalid,
    );
  }

  int _decideValueToPass(int valueProvided) {
    int valueToPass;
    if (valueProvided == null) {
      valueToPass = this.value;
    } else if (valueProvided == -1) {
      valueToPass = null;
    } else {
      valueToPass = valueProvided;
    }
    return valueToPass;
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
}
