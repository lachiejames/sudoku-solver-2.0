import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

class TileSelectedAction {
  final TileState selectedTile;

  TileSelectedAction(this.selectedTile);
}

class TileDeselectedAction {
  final TileState deselectedTile;

  TileDeselectedAction(this.deselectedTile);
}

class RemoveValueFromTileAction {
  final TileState selectedTile;

  RemoveValueFromTileAction(this.selectedTile);
}

class NumberPressedAction {
  final NumberState pressedNumber;

  NumberPressedAction(this.pressedNumber);
}

class SolveButtonPressedAction {
  SolveButtonPressedAction();
}

class StartSolvingSudokuAction {
  StartSolvingSudokuAction();
}

class SudokuSolvedAction {
  final Sudoku solvedSudoku;

  SudokuSolvedAction(this.solvedSudoku);
}

class RestartAction {
  RestartAction();
}

class LoadPlayScreenWithSudokuAction {
  LoadPlayScreenWithSudokuAction();
}
