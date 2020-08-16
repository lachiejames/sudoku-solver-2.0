import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

AppState solveButtonPressedReducer(AppState appState, SolveButtonPressedAction action) {
  Redux.store.dispatch(StartSolvingSudokuAction());

  // Create the new TopText
  TopTextState newTopTextState = appState.topTextState.copyWith(text: MyStrings.topTextAiThinking, color: MyColors.green);

  return appState.copyWith(
    isSolving: true,
    topTextState: newTopTextState,
  );
}
