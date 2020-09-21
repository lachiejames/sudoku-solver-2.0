import 'package:flutter/foundation.dart';

/// All state relating to the NumberWidgets
@immutable
class NumberState {
  final int number;

  final bool isActive;

  NumberState({@required this.number, this.isActive = false});

  @override
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
    List<NumberState> _numberStateList = <NumberState>[];
    for (int n = 1; n <= 9; n++) {
      _numberStateList.add(NumberState(number: n));
    }
    return _numberStateList;
  }
}
