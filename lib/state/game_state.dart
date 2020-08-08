import 'package:flutter/cupertino.dart';
import 'package:sudoku_solver_2/state/number_bar_state.dart';
import 'package:sudoku_solver_2/state/sudoku_state.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

class GameState extends ChangeNotifier {
  SudokuState sudokuState = SudokuState();
  NumberBarState numberBarState = NumberBarState();
  TopTextState topTextState = TopTextState();

  static GameState instance;
  static GameState getInstance() {
    if (instance == null) {
      instance = GameState();
    }
    return instance;
  }

  TileState getTileState(int row, int col) {
    return sudokuState.getTileStateAt(row, col);
  }

  void sentTilePressedEvent(TileState tileState) {
    tileState.isTapped = true;
    notifyListeners();
  }

  void sentNumberPressedEvent(int number) {
    numberBarState.tappedNumber = number;
    notifyListeners();
  }
}
