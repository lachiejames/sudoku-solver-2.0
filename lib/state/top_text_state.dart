import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// All state relating to the TopTextWidgets
class TopTextState {
  final String text;
  final Color color;

  TopTextState({
    @required this.text,
    @required this.color,
  });

  TopTextState copyWith({
    String text,
    Color color,
  }) =>
      TopTextState(
        text: text ?? this.text,
        color: color ?? this.color,
      );
}
