import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';


bool backtracking(Sudoku sudoku) {
  if (sudoku.isFull()) {
    return true;
  }

  TileState tileState = sudoku.getNextTileWithoutValue();

  for (int value in sudoku.getPossibleValuesAtTile(tileState)) {
    sudoku.addValueToTile(value, tileState);

    if (sudoku.allConstraintsSatisfied()) {
      if (backtracking(sudoku)) {
        return true;
      }
    }

    sudoku.addValueToTile(null, tileState);
  }

  return false;
}

Sudoku solveSudoku(Sudoku cs) {
  backtracking(cs);
  return cs;
}
