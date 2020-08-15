import 'package:sudoku_solver_2/algorithm/solver.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

AppState startSolvingSudokuReducer(AppState appState, StartSolvingSudokuAction action) {
  Sudoku sudoku = Sudoku(tileStateMap: appState.tileStateMap);

  // This makes the function not pure unfortunately
  solveSudokuAsync(sudoku).then(
    (solvedSudoku) => Redux.store.dispatch(
      SudokuSolvedAction(solvedSudoku),
    ),
  );

  return appState;
}
