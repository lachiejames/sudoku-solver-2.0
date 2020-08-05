import 'package:flutter/cupertino.dart';

class TileModel extends ChangeNotifier {
  final int row;
  final int col;
  int value;

  TileModel(int value,{this.row, this.col}) {
    this.value = value;
  }

  String toString() {
    return 'TileModel($row, $col) value=${(value != null) ? value : 'null'}';
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

  void setValue(int value) {
    this.value = value;
    notifyListeners();
  }
}
