import 'package:flutter/cupertino.dart';
import 'package:sudoku_solver_2/models/number_bar_model.dart';
import 'package:sudoku_solver_2/models/sudoku_model.dart';
import 'package:sudoku_solver_2/models/tile_model.dart';
import 'package:sudoku_solver_2/models/top_text_model.dart';

class GameModel extends ChangeNotifier {
  SudokuModel sudokuModel = SudokuModel();
  NumberBarModel numberBarModel = NumberBarModel();
  TopTextModel topTextModel = TopTextModel();

  static GameModel instance;
  static GameModel getInstance() {
    if (instance == null) {
      instance = GameModel();
    }
    return instance;
  }

  TileModel getTileModel(int row, int col) {
    return sudokuModel.getTileModelAt(row, col);
  }

  void sentTilePressedEvent(TileModel tileModel) {
    tileModel.isTapped = true;
    notifyListeners();
  }

  void sentNumberPressedEvent(int number) {
    numberBarModel.tappedNumber = number;
    notifyListeners();
  }
}
