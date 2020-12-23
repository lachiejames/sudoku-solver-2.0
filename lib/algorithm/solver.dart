import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;

/// An algorithm for solving 'constraint satisfaction problems', like a Sudoku
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

/// required since backtracking() returns a bool, and this returns a sudoku,
/// which we need for solveSudokuAsync
Sudoku solveSudoku(Sudoku sudoku) {
  backtracking(sudoku);
  return sudoku;
}

// Stream<Sudoku> myStream;
CancelableOperation _solveSudokuCancellableOperation;

/// Solves the sudoku asynchronously with 'compute'
Future<Sudoku> solveSudokuAsync(Sudoku sudoku) async {
  try {
    _solveSudokuCancellableOperation = CancelableOperation.fromFuture(
      compute(solveSudoku, sudoku),
    );

    _solveSudokuCancellableOperation.asStream().listen(
      (solvedSudoku) {
        if (solvedSudoku.isFull() && solvedSudoku.allConstraintsSatisfied()) {
          Redux.store.dispatch(SudokuSolvedAction(solvedSudoku));
          my_values.solveMySudokuButtonPressedTrace.stop();
          my_values.yesSolveItButtonPressedTrace.stop();
        }
      },
    );
  } on Exception catch (e) {
    Redux.store.dispatch(SudokuSolvingErrorAction());
    print(e);
  }

  return sudoku;
}

void stopSolvingSudoku() {
  try {
    _solveSudokuCancellableOperation.cancel();
  } on Exception catch (e) {
    Redux.store.dispatch(SudokuSolvingErrorAction());
    print(e);
  }
}
