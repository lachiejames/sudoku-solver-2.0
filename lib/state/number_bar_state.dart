import 'package:sudoku_solver_2/state/number_state.dart';

class NumberBarState{
  List<NumberState> numberStates;
  int tappedNumber;

  NumberBarState() {
    numberStates = this.initNumberStates();
  }

  List<NumberState> initNumberStates() {
    List<NumberState> _numberStates = [];
    for (int number = 1; number <= 9; number++) {
      _numberStates.add(NumberState(number: number));
    }
    return _numberStates;
  }

  String toString() {
    return '';
  }

  int getPressedNumber() {
    for (NumberState numberState in this.numberStates) {
      if (numberState.isTapped) {
        return numberState.number;
      }
    }
    return null;
  }

  void numberTappedEvent(int numberTapped) {
    this.tappedNumber = numberTapped;
  }
}
