import 'package:sudoku_solver_2/constants/constants.dart';

import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';
import 'package:redux/redux.dart';

/// Contains all state reducers used by the TopTextState
final Reducer<TopTextState> topTextStateReducer =
    combineReducers<TopTextState>(<TopTextState Function(TopTextState, dynamic)>[
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

TopTextState _setTopTextToPickATile(TopTextState topTextState, TileDeselectedAction action) =>
    topTextState.copyWith(text: topTextNoTileSelected, color: white);

TopTextState _setTopTextToPickATile2(TopTextState topTextState, NumberPressedAction action) =>
    topTextState.copyWith(text: topTextNoTileSelected, color: white);

TopTextState _setTopTextToPickATile3(TopTextState topTextState, RestartAction action) => topTextState.copyWith(
      text: (Redux.store.state.screenState == ScreenState.solveWithCameraScreen)
          ? topTextTakingPhoto
          : topTextNoTileSelected,
      color: white,
    );

TopTextState _setTopTextToPickATile4(TopTextState topTextState, NewGameButtonPressedAction action) =>
    topTextState.copyWith(text: topTextNoTileSelected, color: white);

TopTextState _setTopTextToPickANumberOrTapToRemove(TopTextState topTextState, TileSelectedAction action) =>
    topTextState.copyWith(
      text: (action.selectedTile.value != null) ? topTextTileWithValueSelected : topTextTileSelected,
      color: white,
    );

TopTextState _setTopTextToAiThinking(TopTextState topTextState, SolveSudokuAction action) =>
    topTextState.copyWith(text: topTextWhenSolving, color: white);

TopTextState _setTopTextToSolved(TopTextState topTextState, SudokuSolvedAction action) =>
    topTextState.copyWith(text: topTextSolved, color: green);

TopTextState _setTopTextAlignWithCamera(TopTextState topTextState, ChangeScreenAction action) {
  if (action.screenState == ScreenState.solveWithCameraScreen) {
    return topTextState.copyWith(text: topTextTakingPhoto, color: white);
  } else if (action.screenState == ScreenState.homeScreen) {
    return topTextState.copyWith(text: topTextHome, color: white);
  } else {
    return topTextState.copyWith(text: topTextNoTileSelected, color: white);
  }
}

TopTextState _upateGameStateReducer(TopTextState topTextState, ApplyGameStateChangesAction action) {
  if (action.gameState == GameState.solved) {
    return topTextState.copyWith(text: topTextSolved, color: green);
  } else {
    return topTextState;
  }
}

TopTextState _stopSolvingSudokuReducer(TopTextState topTextState, StopSolvingSudokuAction action) =>
    topTextState.copyWith(
      text: (Redux.store.state.screenState == ScreenState.solveWithCameraScreen)
          ? topTextTakingPhoto
          : topTextNoTileSelected,
      color: white,
    );

TopTextState _stopProcessingPhotoReducer(TopTextState topTextState, StopProcessingPhotoAction action) =>
    topTextState.copyWith(
      text: topTextTakingPhoto,
      color: white,
    );

TopTextState _takePhotoReducer(TopTextState topTextState, TakePhotoAction action) =>
    topTextState.copyWith(text: topTextConstructingSudoku, color: white);

TopTextState _retakePhotoReducer(TopTextState topTextState, RetakePhotoAction action) =>
    topTextState.copyWith(text: topTextTakingPhoto, color: white);

TopTextState _photoProcessedReducer(TopTextState topTextState, PhotoProcessedAction action) =>
    topTextState.copyWith(text: topTextVerifySudoku, color: white);

TopTextState _cameraNotLoadedErrorReducer(TopTextState topTextState, CameraNotLoadedErrorAction action) =>
    topTextState.copyWith(text: topTextCameraNotFoundError, color: red);

TopTextState _processingPhotoErrorReducer(TopTextState topTextState, PhotoProcessingErrorAction action) =>
    topTextState.copyWith(text: topTextPhotoProcessingError, color: red);

TopTextState _sudokuSolvingTimeoutErrorReducer(TopTextState topTextState, SudokuSolvingTimeoutErrorAction action) =>
    topTextState.copyWith(text: topTextSolvingTimeoutError, color: red);

TopTextState _sudokuSolvingInvalidErrorReducer(TopTextState topTextState, SudokuSolvingInvalidErrorAction action) =>
    topTextState.copyWith(text: topTextSudokuInvalidError, color: red);

TopTextState _returnToHomeReducer(TopTextState topTextState, ReturnToHomeAction action) =>
    topTextState.copyWith(text: topTextHome, color: white);
