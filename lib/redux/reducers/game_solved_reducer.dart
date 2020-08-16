import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

AppState gameSolvedReducer(AppState appState, GameSolvedAction action) {
  assert(appState.tileStateMap.length == 81);

  // Create the new TopText
  TopTextState newTopTextState = appState.topTextState.copyWith(text: MyStrings.topTextSolved, color: MyColors.green);

  return appState.copyWith(
    topTextState: newTopTextState,
    isSolved: true,
  );
}
