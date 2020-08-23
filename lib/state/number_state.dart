import 'package:flutter/foundation.dart';

@immutable
class NumberState {
  final int number;

  final bool isActive;

  NumberState({@required this.number, this.isActive = false});

  String toString() {
    return 'NumberState($number)';
  }

  NumberState copyWith({
    int number,
    bool isActive,
  }) {
    return NumberState(
      number: number ?? this.number,
      isActive: isActive ?? this.isActive,
    );
  }

  static List<NumberState> initNumberStateList() {
    List<NumberState> _numberStateList = List<NumberState>();
    for (int n = 1; n <= 9; n++) {
      _numberStateList.add(NumberState(number: n));
    }
    return _numberStateList;
  }
}
