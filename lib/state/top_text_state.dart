import 'package:flutter/foundation.dart';

class TopTextState {
  final String text;

  TopTextState({@required this.text});

  TopTextState copyWith({String text}) {
    return TopTextState(text: text);
  }
}
