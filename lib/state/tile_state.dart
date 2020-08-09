import 'package:flutter/foundation.dart';

@immutable
class TileState {
  final int row;
  final int col;
  final int value;
  final bool isTapped;

  TileState({this.row, this.col, this.value, this.isTapped = false});

  String toString() {
    return 'TileState(row=$row, col=$col, value=${(value != null) ? value : 'null'}, isTapped=${this.isTapped})';
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
    int row,
    int col,
    int value,
    bool isTapped,
  }) {
    return TileState(
      row: row ?? this.row,
      col: col ?? this.col,
      value: value ?? this.value,
      isTapped: isTapped ?? this.isTapped,
    );
  }
}
