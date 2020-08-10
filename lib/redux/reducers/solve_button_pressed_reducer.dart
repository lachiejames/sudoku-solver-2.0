import 'package:sudoku_solver_2/algorithm/solver.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

AppState solveButtonPressedReducer(AppState appState, SolveButtonPressedAction action) {
  Sudoku sudoku = Sudoku(tileStateMap: appState.tileStateMap);

  // This makes the function not pure unfortunately
  solveSudokuAsync(sudoku).then(
    (solvedSudoku) => Redux.store.dispatch(
      SudokuSolvedAction(solvedSudoku),
    ),
  );

  // final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  // sudoku.tileStateMap.forEach((tileKey, tileState) {
  //   newTileStateMap.putIfAbsent(tileKey, () => ));
  // });

  return appState.copyWith(
    isSolving: true,
  );
}
