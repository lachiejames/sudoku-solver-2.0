import 'package:sudoku_solver_2/algorithm/sudoku_state.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

SudokuState cspState;

bool backtracking(SudokuState sudokuState) {
  if (sudokuState.isFull()) {
    return true;
  }

  TileState tileState = sudokuState.getNextTileWithoutValue();

  for (int value in sudokuState.getPossibleValuesAtTile(tileState)) {
    // This deletes the old tile and makes a new tile
    cspState.addValueToTile(value, tileState);

    if (cspState.allConstraintsSatisfied()) {
      if (backtracking(cspState)) {
        return true;
      }
    }
    cspState.addValueToTile(null, tileState);
  }

  return false;
}

SudokuState solveSudoku(SudokuState cs) {
  cspState = cs;
  backtracking(cs);
  return cs;
}
