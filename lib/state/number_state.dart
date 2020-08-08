import 'package:flutter/cupertino.dart';

class NumberState {
  final int number;

  bool isTapped = false;

  NumberState({@required this.number});

  String toString() {
    return 'NumberState($number)';
  }

  void setIsTapped(bool isTapped) {
    this.isTapped = isTapped;
  }

  NumberState copyWith({@required int newNumber}) {
    print('copyWith on $this -> $newNumber');
    return NumberState(number: newNumber);
  }
}
