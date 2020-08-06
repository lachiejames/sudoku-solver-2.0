import 'package:flutter/cupertino.dart';

class NumberModel extends ChangeNotifier {
  final int number;
  
  bool isTapped = false;

  NumberModel({@required this.number});

  String toString() {
    return 'NumberModel($number)';
  }

  void setIsTapped(bool isTapped) {
    this.isTapped = isTapped;
    notifyListeners();
  }
}
