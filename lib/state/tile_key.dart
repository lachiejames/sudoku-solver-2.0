import 'package:flutter/cupertino.dart';

@immutable
class TileKey {
  final int row;
  final int col;

  TileKey({this.row, this.col});

  @override
  bool operator ==(o) => row == o.row && col == o.col;

  @override
  int get hashCode => this.row * 11 + col * 89;

  @override
  String toString() {
    return 'TileKey($row, $col)';
  }

  static List<TileKey> makeTileKeysFromRowsAndCols(
      List<int> rows, List<int> cols) {
    List<TileKey> _tileKeys = <TileKey>[];
    for (int row in rows) {
      for (int col in cols) {
        _tileKeys.add(TileKey(row: row, col: col));
      }
    }
    return _tileKeys;
  }

  static List<TileKey> getTileKeysInSegment(int segment) {
    List<TileKey> _tileKeys = <TileKey>[];

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
}
