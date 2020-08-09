import 'package:flutter/cupertino.dart';

@immutable
class NumberState {
  final int number;

  final bool isTapped;

  NumberState({@required this.number, this.isTapped = false});

  String toString() {
    return 'NumberState($number)';
  }

  NumberState copyWith({
    int number,
    int isTapped,
  }) {
    return NumberState(
      number: number ?? this.number,
      isTapped: isTapped ?? this.isTapped,
    );
  }
}
