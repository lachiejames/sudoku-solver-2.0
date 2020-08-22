import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';
import 'package:redux/redux.dart';

final Reducer<TopTextState> topTextStateReducer = combineReducers<TopTextState>([
  TypedReducer<TopTextState, TileSelectedAction>(_setTopTextToPickANumberOrTapToRemove),
  TypedReducer<TopTextState, TileDeselectedAction>(_setTopTextToPickATile),
  TypedReducer<TopTextState, NumberPressedAction>(_setTopTextToPickATile2),
  TypedReducer<TopTextState, RestartAction>(_setTopTextToPickATile3),
  TypedReducer<TopTextState, SolveButtonPressedAction>(_setTopTextToAiThinking),
  TypedReducer<TopTextState, SudokuSolvedAction>(_setTopTextToSolved),
  TypedReducer<TopTextState, GameSolvedAction>(_setTopTextToSolved2),
  TypedReducer<TopTextState, ChangeScreenAction>(_setTopTextAlignWithCamera),
]);

TopTextState _setTopTextToPickATile(TopTextState topTextState, TileDeselectedAction action) {
  return topTextState.copyWith(text: MyStrings.topTextPickATile, color: MyColors.white);
}

TopTextState _setTopTextToPickATile2(TopTextState topTextState, NumberPressedAction action) {
  return topTextState.copyWith(text: MyStrings.topTextPickATile, color: MyColors.white);
}

TopTextState _setTopTextToPickATile3(TopTextState topTextState, RestartAction action) {
  return topTextState.copyWith(text: MyStrings.topTextPickATile, color: MyColors.white);
}

TopTextState _setTopTextToPickANumberOrTapToRemove(TopTextState topTextState, TileSelectedAction action) {
  return topTextState.copyWith(
    text: (action.selectedTile.value != null) ? MyStrings.topTextTapToRemove : MyStrings.topTextPickANumber,
    color: MyColors.white,
  );
}

TopTextState _setTopTextToAiThinking(TopTextState topTextState, SolveButtonPressedAction action) {
  return topTextState.copyWith(text: MyStrings.topTextAiThinking, color: MyColors.white);
}

TopTextState _setTopTextToSolved(TopTextState topTextState, SudokuSolvedAction action) {
  return topTextState.copyWith(text: MyStrings.topTextSolved, color: MyColors.green);
}

TopTextState _setTopTextToSolved2(TopTextState topTextState, GameSolvedAction action) {
  return topTextState.copyWith(text: MyStrings.topTextSolved, color: MyColors.green);
}

TopTextState _setTopTextAlignWithCamera(TopTextState topTextState, ChangeScreenAction action) {
  if (action.screenState == ScreenState.SolveWithCameraScreen) {
    return topTextState.copyWith(text: MyStrings.topTextAlignWithTheCamera, color: MyColors.white);
  } else if (action.screenState == ScreenState.HomeScreen) {
    return topTextState.copyWith(text: MyStrings.topTextHome, color: MyColors.white);
  } else {
    return topTextState.copyWith(text: MyStrings.topTextPickATile, color: MyColors.white);
  }
}
