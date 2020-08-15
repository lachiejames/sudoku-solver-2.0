import 'package:flutter/foundation.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

bool backtracking(Sudoku sudoku) {
  if (sudoku.isFull()) {
    return true;
  }

  TileState tileState = sudoku.getNextTileWithoutValue();
  assert(tileState != null);
  for (int value in sudoku.getPossibleValuesAtTile(tileState)) {
    assert(value != null);
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

// required since backtracking() returns a bool, and this returns a sudoku,
// which we need for solveSudokuAsync
Sudoku _solveSudoku(Sudoku sudoku) {
  backtracking(sudoku);
  return sudoku;
}

Future<Sudoku> solveSudokuAsync(Sudoku sudoku) async {
  Sudoku solvedSudoku = await compute(_solveSudoku, sudoku);
  return solvedSudoku;
}
