import 'package:sudoku_solver_2/constants/constants.dart' as constants;

import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
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
  TypedReducer<TopTextState, ChangeScreenAction>(_setTopTextAlignWithCamera),
  TypedReducer<TopTextState, NewGameButtonPressedAction>(_setTopTextToPickATile4),
  TypedReducer<TopTextState, ApplyGameStateChangesAction>(_upateGameStateReducer),
  TypedReducer<TopTextState, StopSolvingSudokuAction>(_stopSolvingSudokuReducer),
  TypedReducer<TopTextState, TakePhotoAction>(_takePhotoReducer),
  TypedReducer<TopTextState, PhotoProcessedAction>(_photoProcessedReducer),
  TypedReducer<TopTextState, RetakePhotoAction>(_retakePhotoReducer),
  TypedReducer<TopTextState, StopProcessingPhotoAction>(_stopProcessingPhotoReducer),
  TypedReducer<TopTextState, CameraNotLoadedErrorAction>(_cameraNotLoadedErrorReducer),
  TypedReducer<TopTextState, PhotoProcessingErrorAction>(_processingPhotoErrorReducer),
  TypedReducer<TopTextState, SudokuSolvingTimeoutErrorAction>(_sudokuSolvingTimeoutErrorReducer),
  TypedReducer<TopTextState, SudokuSolvingInvalidErrorAction>(_sudokuSolvingInvalidErrorReducer),
  TypedReducer<TopTextState, ReturnToHomeAction>(_returnToHomeReducer),
]);

TopTextState _setTopTextToPickATile(TopTextState topTextState, TileDeselectedAction action) {
  return topTextState.copyWith(text: constants.topTextNoTileSelected, color: constants.white);
}

TopTextState _setTopTextToPickATile2(TopTextState topTextState, NumberPressedAction action) {
  return topTextState.copyWith(text: constants.topTextNoTileSelected, color: constants.white);
}

TopTextState _setTopTextToPickATile3(TopTextState topTextState, RestartAction action) {
  return topTextState.copyWith(
    text: (Redux.store.state.screenState == ScreenState.solveWithCameraScreen)
        ? constants.topTextTakingPhoto
        : constants.topTextNoTileSelected,
    color: constants.white,
  );
}

TopTextState _setTopTextToPickATile4(TopTextState topTextState, NewGameButtonPressedAction action) {
  return topTextState.copyWith(text: constants.topTextNoTileSelected, color: constants.white);
}

TopTextState _setTopTextToPickANumberOrTapToRemove(TopTextState topTextState, TileSelectedAction action) {
  return topTextState.copyWith(
    text:
        (action.selectedTile.value != null) ? constants.topTextTileWithValueSelected : constants.topTextTileSelected,
    color: constants.white,
  );
}

TopTextState _setTopTextToAiThinking(TopTextState topTextState, SolveSudokuAction action) {
  return topTextState.copyWith(text: constants.topTextWhenSolving, color: constants.white);
}

TopTextState _setTopTextToSolved(TopTextState topTextState, SudokuSolvedAction action) {
  return topTextState.copyWith(text: constants.topTextSolved, color: constants.green);
}

TopTextState _setTopTextAlignWithCamera(TopTextState topTextState, ChangeScreenAction action) {
  if (action.screenState == ScreenState.solveWithCameraScreen) {
    return topTextState.copyWith(text: constants.topTextTakingPhoto, color: constants.white);
  } else if (action.screenState == ScreenState.homeScreen) {
    return topTextState.copyWith(text: constants.topTextHome, color: constants.white);
  } else {
    return topTextState.copyWith(text: constants.topTextNoTileSelected, color: constants.white);
  }
}

TopTextState _upateGameStateReducer(TopTextState topTextState, ApplyGameStateChangesAction action) {
  if (action.gameState == GameState.solved) {
    return topTextState.copyWith(text: constants.topTextSolved, color: constants.green);
  } else {
    return topTextState;
  }
}

TopTextState _stopSolvingSudokuReducer(TopTextState topTextState, StopSolvingSudokuAction action) {
  return topTextState.copyWith(
    text: (Redux.store.state.screenState == ScreenState.solveWithCameraScreen)
        ? constants.topTextTakingPhoto
        : constants.topTextNoTileSelected,
    color: constants.white,
  );
}

TopTextState _stopProcessingPhotoReducer(TopTextState topTextState, StopProcessingPhotoAction action) {
  return topTextState.copyWith(
    text: constants.topTextTakingPhoto,
    color: constants.white,
  );
}

TopTextState _takePhotoReducer(TopTextState topTextState, TakePhotoAction action) {
  return topTextState.copyWith(text: constants.topTextConstructingSudoku, color: constants.white);
}

TopTextState _retakePhotoReducer(TopTextState topTextState, RetakePhotoAction action) {
  return topTextState.copyWith(text: constants.topTextTakingPhoto, color: constants.white);
}

TopTextState _photoProcessedReducer(TopTextState topTextState, PhotoProcessedAction action) {
  return topTextState.copyWith(text: constants.topTextVerifySudoku, color: constants.white);
}

TopTextState _cameraNotLoadedErrorReducer(TopTextState topTextState, CameraNotLoadedErrorAction action) {
  return topTextState.copyWith(text: constants.topTextCameraNotFoundError, color: constants.red);
}

TopTextState _processingPhotoErrorReducer(TopTextState topTextState, PhotoProcessingErrorAction action) {
  return topTextState.copyWith(text: constants.topTextPhotoProcessingError, color: constants.red);
}

TopTextState _sudokuSolvingTimeoutErrorReducer(TopTextState topTextState, SudokuSolvingTimeoutErrorAction action) {
  return topTextState.copyWith(text: constants.topTextSolvingTimeoutError, color: constants.red);
}

TopTextState _sudokuSolvingInvalidErrorReducer(TopTextState topTextState, SudokuSolvingInvalidErrorAction action) {
  return topTextState.copyWith(text: constants.topTextSudokuInvalidError, color: constants.red);
}

TopTextState _returnToHomeReducer(TopTextState topTextState, ReturnToHomeAction action) {
  return topTextState.copyWith(text: constants.topTextHome, color: constants.white);
}
