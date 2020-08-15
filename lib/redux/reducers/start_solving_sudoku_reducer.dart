import 'package:sudoku_solver_2/algorithm/solver.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

AppState startSolvingSudokuReducer(AppState appState, StartSolvingSudokuAction action) {
  Sudoku sudoku = Sudoku(tileStateMap: appState.tileStateMap);
  assert(sudoku.tileStateMap.length == 81);

  // This makes the function not pure unfortunately
  solveSudokuAsync(sudoku).then((solvedSudoku) {
    assert(solvedSudoku.tileStateMap.length == 81);
    assert(solvedSudoku.isFull());
    assert(solvedSudoku.allConstraintsSatisfied());
    Redux.store.dispatch(
      SudokuSolvedAction(solvedSudoku),
    );
  });

  return appState;
}
