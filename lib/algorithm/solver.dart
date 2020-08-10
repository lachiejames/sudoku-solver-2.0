import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

Sudoku cspState;

bool backtracking(Sudoku sudoku) {
  if (sudoku.isFull()) {
    return true;
  }

  TileState tileState = sudoku.getNextTileWithoutValue();

  for (int value in sudoku.getPossibleValuesAtTile(tileState)) {
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

Sudoku solveSudoku(Sudoku cs) {
  cspState = cs;
  backtracking(cs);
  return cs;
}
