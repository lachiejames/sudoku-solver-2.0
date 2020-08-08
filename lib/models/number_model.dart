import 'package:flutter/cupertino.dart';

class NumberState extends ChangeNotifier {
  final int number;

  bool isTapped = false;

  NumberState({@required this.number});

  String toString() {
    return 'NumberModel($number)';
  }

  void setIsTapped(bool isTapped) {
    this.isTapped = isTapped;
    notifyListeners();
  }

  NumberState copyWith({@required int newNumber}) {
    print('copyWith on $this -> $newNumber');
    return NumberState(number: newNumber);
  }
}
