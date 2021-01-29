import 'package:meta/meta.dart';

/// Allows us to get a tile by its row/column in O(1) time, using Map<TileKey, TileState>
@immutable
class TileKey {
  final int row;
  final int col;

  const TileKey({this.row, this.col});

  @override
  bool operator ==(dynamic other) => row == other.row && col == other.col;

  @override
  int get hashCode => row * 11 + col * 89;

  @override
  String toString() => 'TileKey($row, $col)';

  static List<TileKey> makeTileKeysFromRowsAndCols(List<int> rows, List<int> cols) {
    final List<TileKey> _tileKeys = <TileKey>[];
    for (final int row in rows) {
      for (final int col in cols) {
        _tileKeys.add(TileKey(row: row, col: col));
      }
    }
    return _tileKeys;
  }

  static List<TileKey> getTileKeysInSegment(int segment) {
    final List<TileKey> _tileKeys = <TileKey>[];

    if (segment == 1) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols(<int>[1, 2, 3], <int>[1, 2, 3]));
    } else if (segment == 2) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols(<int>[1, 2, 3], <int>[4, 5, 6]));
    } else if (segment == 3) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols(<int>[1, 2, 3], <int>[7, 8, 9]));
    } else if (segment == 4) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols(<int>[4, 5, 6], <int>[1, 2, 3]));
    } else if (segment == 5) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols(<int>[4, 5, 6], <int>[4, 5, 6]));
    } else if (segment == 6) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols(<int>[4, 5, 6], <int>[7, 8, 9]));
    } else if (segment == 7) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols(<int>[7, 8, 9], <int>[1, 2, 3]));
    } else if (segment == 8) {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols(<int>[7, 8, 9], <int>[4, 5, 6]));
    } else {
      _tileKeys.addAll(makeTileKeysFromRowsAndCols(<int>[7, 8, 9], <int>[7, 8, 9]));
    }
    return _tileKeys;
  }
}
