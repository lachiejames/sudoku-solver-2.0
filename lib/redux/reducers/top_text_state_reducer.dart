import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';
import 'package:redux/redux.dart';

/// Contains all state reducers used by the TopTextState
final Reducer<TopTextState> topTextStateReducer = combineReducers<TopTextState>([
  TypedReducer<TopTextState, TileSelectedAction>(_setTopTextToPickANumberOrTapToRemove),
  TypedReducer<TopTextState, TileDeselectedAction>(_setTopTextToPickATile),
  TypedReducer<TopTextState, NumberPressedAction>(_setTopTextToPickATile2),
  TypedReducer<TopTextState, RestartAction>(_setTopTextToPickATile3),
  TypedReducer<TopTextState, SolveSudokuAction>(_setTopTextToAiThinking),
  TypedReducer<TopTextState, SudokuSolvedAction>(_setTopTextToSolved),
  TypedReducer<TopTextState, GameSolvedAction>(_setTopTextToSolved2),
  TypedReducer<TopTextState, ChangeScreenAction>(_setTopTextAlignWithCamera),
  TypedReducer<TopTextState, CheckIfSolvedAction>(_checkIfSolvedReducer),
  TypedReducer<TopTextState, NewGameButtonPressedAction>(_setTopTextToPickATile4),
]);

TopTextState _setTopTextToPickATile(TopTextState topTextState, TileDeselectedAction action) {
  return topTextState.copyWith(text: my_strings.topTextNoTileSelected, color: my_colors.white);
}

TopTextState _setTopTextToPickATile2(TopTextState topTextState, NumberPressedAction action) {
  return topTextState.copyWith(text: my_strings.topTextNoTileSelected, color: my_colors.white);
}

TopTextState _setTopTextToPickATile3(TopTextState topTextState, RestartAction action) {
  return topTextState.copyWith(text: my_strings.topTextNoTileSelected, color: my_colors.white);
}

TopTextState _setTopTextToPickATile4(TopTextState topTextState, NewGameButtonPressedAction action) {
  return topTextState.copyWith(text: my_strings.topTextNoTileSelected, color: my_colors.white);
}

TopTextState _setTopTextToPickANumberOrTapToRemove(
    TopTextState topTextState, TileSelectedAction action) {
  return topTextState.copyWith(
    text: (action.selectedTile.value != null)
        ? my_strings.topTextTileWithValueSelected
        : my_strings.topTextTileSelected,
    color: my_colors.white,
  );
}

TopTextState _setTopTextToAiThinking(TopTextState topTextState, SolveSudokuAction action) {
  return topTextState.copyWith(text: my_strings.topTextWhenSolving, color: my_colors.white);
}

TopTextState _setTopTextToSolved(TopTextState topTextState, SudokuSolvedAction action) {
  return topTextState.copyWith(text: my_strings.topTextSolved, color: my_colors.green);
}

TopTextState _setTopTextToSolved2(TopTextState topTextState, GameSolvedAction action) {
  return topTextState.copyWith(text: my_strings.topTextSolved, color: my_colors.green);
}

TopTextState _setTopTextAlignWithCamera(TopTextState topTextState, ChangeScreenAction action) {
  if (action.screenState == ScreenState.solveWithCameraScreen) {
    return topTextState.copyWith(text: my_strings.topTextTakingPhoto, color: my_colors.white);
  } else if (action.screenState == ScreenState.homeScreen) {
    return topTextState.copyWith(text: my_strings.topTextHome, color: my_colors.white);
  } else {
    return topTextState.copyWith(text: my_strings.topTextNoTileSelected, color: my_colors.white);
  }
}

TopTextState _checkIfSolvedReducer(TopTextState topTextState, CheckIfSolvedAction action) {
  int numValues = 0;

  for (TileState tileState in action.tileStateMap.values) {
    if (tileState.value != null) {
      numValues++;
    }
  }

  return (numValues == 81)
      ? topTextState.copyWith(text: my_strings.topTextSolved, color: my_colors.green)
      : topTextState;
}
