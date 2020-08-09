import 'package:flutter/cupertino.dart';
import 'package:sudoku_solver_2/state/number_state.dart';

@immutable
class NumberBarState {
  final List<NumberState> numberStates;

  NumberBarState() : numberStates = _initNumberStates();

  static List<NumberState> _initNumberStates() {
    List<NumberState> _numberStates = [];
    for (int number = 1; number <= 9; number++) {
      _numberStates.add(NumberState(number: number));
    }
    return _numberStates;
  }

  String toString() {
    return '';
  }
}
