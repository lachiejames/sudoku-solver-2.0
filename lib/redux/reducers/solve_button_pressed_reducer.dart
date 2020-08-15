import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

AppState solveButtonPressedReducer(AppState appState, SolveButtonPressedAction action) {
  Redux.store.dispatch(StartSolvingSudokuAction());

  return appState.copyWith(
    isSolving: true,
  );
}
