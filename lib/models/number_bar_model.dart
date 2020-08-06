import 'package:flutter/cupertino.dart';
import 'package:sudoku_solver_2/models/number_model.dart';

class NumberBarModel extends ChangeNotifier{
  List<NumberModel> numberModels;
  int tappedNumber;

  static NumberBarModel instance;
  static NumberBarModel getInstance() {
    if (instance == null) {
      instance = NumberBarModel();
    }
    return instance;
  }

  NumberBarModel() {
    numberModels = this.initNumberModels();
  }

  List<NumberModel> initNumberModels() {
    List<NumberModel> _numberModels = [];
    for (int number = 1; number <= 9; number++) {
      _numberModels.add(NumberModel(number: number));
    }
    return _numberModels;
  }

  String toString() {
    return '';
  }

  int getPressedNumber() {
    for (NumberModel numberModel in this.numberModels) {
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
