import 'package:flutter/cupertino.dart';

@immutable
class TileKey {
  final int row;
  final int col;

  TileKey({this.row, this.col});

  bool operator ==(o) => row == o.row && col == o.col;
  int get hashCode => this.row * 11 + col * 89;

  String toString() {
    return 'TileKey($row, $col)';
  }
}
