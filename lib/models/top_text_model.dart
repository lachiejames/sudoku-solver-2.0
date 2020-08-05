import 'package:flutter/foundation.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';

class TopTextModel extends ChangeNotifier {
  String text = MyStrings.topTextPickATile;
  TopTextModel();

  void setText(String newText) {
    this.text = newText;
    notifyListeners();
  }
}