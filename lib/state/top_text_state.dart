import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';

class TopTextState {
  final String text;
  final Color color;

  TopTextState({
    @required this.text,
    @required this.color,
  });

  static TopTextState initialState() {
    return TopTextState(text: MyStrings.topTextPickATile, color: MyColors.white);
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
