import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

double timeElapsed, startTime;

/// An algorithm for solving 'constraint satisfaction problems', like a Sudoku
bool backtracking(Sudoku sudoku) {
  timeElapsed = DateTime.now().millisecondsSinceEpoch - startTime;
  if (timeElapsed > maxSolveTime) {
    throw Exception('SudokuSolvingTimeoutException');
  }

  if (sudoku.isFull()) {
    return true;
  }

  final TileState tileState = sudoku.getNextTileWithoutValue();
  assert(tileState != null);
  for (final int value in sudoku.getPossibleValuesAtTile(tileState)) {
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
  startTime = DateTime.now().millisecondsSinceEpoch.toDouble();

  if (backtracking(sudoku)) {
    return sudoku;
  }
  throw Exception('InvalidSudokuException');
}

// Stream<Sudoku> myStream;
CancelableOperation<dynamic> _solveSudokuCancellableOperation;

/// Solves the sudoku asynchronously with 'compute'
Future<Sudoku> solveSudokuAsync(Sudoku sudoku) async {
  _solveSudokuCancellableOperation = CancelableOperation<dynamic>.fromFuture(
    compute(solveSudoku, sudoku)
      .catchError((dynamic e) async {
        await logError('ERROR: sudoku could not be solved', e);
        await playSound(processingErrorSound);

        if (e.message == 'Exception: SudokuSolvingTimeoutException') {
          Redux.store.dispatch(SudokuSolvingTimeoutErrorAction());
        } else {
          Redux.store.dispatch(SudokuSolvingInvalidErrorAction());
        }
        return sudoku;
      }),
  );

  _solveSudokuCancellableOperation.asStream().listen((dynamic solvedSudoku) async {
    if (solvedSudoku.isFull() && solvedSudoku.allConstraintsSatisfied()) {
      await playSound(gameSolvedSound);
      await solveSudokuButtonPressedTrace.stop();
      Redux.store.dispatch(SudokuSolvedAction(solvedSudoku));
    }
  });

  return sudoku;
}

void stopSolvingSudoku() {
  _solveSudokuCancellableOperation.cancel();
}
