import 'package:flutter/cupertino.dart';
import 'package:sudoku_solver_2/models/number_model.dart';

class NumberBarModel extends ChangeNotifier{
  List<NumberState> numberModels;
  int tappedNumber;

  NumberBarModel() {
    numberModels = this.initNumberModels();
  }

  List<NumberState> initNumberModels() {
    List<NumberState> _numberModels = [];
    for (int number = 1; number <= 9; number++) {
      _numberModels.add(NumberState(number: number));
    }
    return _numberModels;
  }

  String toString() {
    return '';
  }

  int getPressedNumber() {
    for (NumberState numberModel in this.numberModels) {
      if (numberModel.isTapped) {
        return numberModel.number;
      }
    }
    return null;
  }

  void numberTappedEvent(int numberTapped) {
    this.tappedNumber = numberTapped;
    notifyListeners();
  }
}
