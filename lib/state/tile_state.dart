class TileState {
  final int row;
  final int col;
  final bool isOriginalTile;

  int value;
  bool isTapped;

  TileState({
    this.row,
    this.col,
    this.value,
    this.isTapped = false,
    this.isOriginalTile = false,
  });

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
    int value,
    bool isTapped,
  }) {
    return TileState(
      row: this.row,
      col: this.col,
      value: _decideValueToPass(value),
      isTapped: isTapped ?? this.isTapped,
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
}
