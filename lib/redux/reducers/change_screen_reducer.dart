import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

AppState changeScreenReducer(AppState appState, ChangeScreenAction action) {
  // Create the new TopText
  TopTextState newTopTextState;
  if (action.screenState == ScreenState.SolveWithCameraScreen) {
    newTopTextState = appState.topTextState.copyWith(text: MyStrings.topTextAlignWithTheCamera, color: MyColors.white);
  } else {
    newTopTextState = appState.topTextState.copyWith(text: MyStrings.topTextPickATile, color: MyColors.white);
  }

  return appState.copyWith(
    topTextState: newTopTextState,
    isSolved: true,
  );
}
