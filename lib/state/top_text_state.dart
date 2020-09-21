import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;

/// All state relating to the TopTextWidgets
class TopTextState {
  final String text;
  final Color color;

  TopTextState({
    @required this.text,
    @required this.color,
  });

  static TopTextState initialState() {
    return TopTextState(text: my_strings.topTextNoTileSelected, color: my_colors.white);
  }

  TopTextState copyWith({
    String text,
    Color color,
  }) {
    return TopTextState(
      text: text ?? this.text,
      color: color ?? this.color,
    );
  }
}
