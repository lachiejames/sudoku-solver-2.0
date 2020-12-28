import 'package:sudoku_solver_2/algorithm/photo_processor.dart';
import 'package:sudoku_solver_2/algorithm/solver.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';

/// Contains all state reducers used by GameState
final Reducer<GameState> gameStateReducer = combineReducers<GameState>([
  TypedReducer<GameState, SolveSudokuAction>(_solveSudokuReducer),
  TypedReducer<GameState, SudokuSolvedAction>(_sudokuSolvedReducer),
  TypedReducer<GameState, RestartAction>(_setToDefault),
  TypedReducer<GameState, TakePhotoAction>(_takePhotoReducer),
  TypedReducer<GameState, PhotoProcessedAction>(_photoProcessedReducer),
  TypedReducer<GameState, RetakePhotoAction>(_retakePhotoReducer),
  TypedReducer<GameState, UpdateGameStateAction>(_updateGameStateReducer),
  TypedReducer<GameState, NewGameButtonPressedAction>(_newGameButtonPressedReducer),
  TypedReducer<GameState, GameSolvedAction>(_gameSolvedReducerReducer),
  TypedReducer<GameState, StopSolvingSudokuAction>(_stopSolvingSudokuReducer),
  TypedReducer<GameState, ChangeScreenAction>(_changeScreenReducer),
  TypedReducer<GameState, StopProcessingPhotoAction>(_stopProcessingPhotoReducer),
  TypedReducer<GameState, CameraNotLoadedErrorAction>(_cameraNotLoadedErrorReducer),
  TypedReducer<GameState, PhotoProcessingErrorAction>(_processingPhotoErrorReducer),
  TypedReducer<GameState, SudokuSolvingTimeoutErrorAction>(_sudokuSolvingTimeoutErrorReducer),
  TypedReducer<GameState, SudokuSolvingInvalidErrorAction>(_sudokuSolvingInvalidErrorReducer),
]);

GameState _solveSudokuReducer(GameState gameState, SolveSudokuAction action) {
  Sudoku sudoku = Sudoku(tileStateMap: Redux.store.state.tileStateMap);
  assert(sudoku.tileStateMap.length == 81);

  solveSudokuAsync(sudoku);

  return GameState.isSolving;
}

GameState _stopSolvingSudokuReducer(GameState gameState, StopSolvingSudokuAction action) {
  stopSolvingSudoku();
  if (Redux.store.state.screenState == ScreenState.solveWithCameraScreen) {
    return GameState.photoProcessed;
  } else {
    return GameState.normal;
  }
}

GameState _sudokuSolvedReducer(GameState gameState, SudokuSolvedAction action) {
  return GameState.solved;
}

GameState _setToDefault(GameState gameState, RestartAction action) {
  return (Redux.store.state.screenState == ScreenState.solveWithCameraScreen)
      ? GameState.takingPhoto
      : GameState.normal;
}

GameState _takePhotoReducer(GameState gameState, TakePhotoAction action) {
  processPhoto(action.imageFile);
  return GameState.processingPhoto;
}

GameState _photoProcessedReducer(GameState gameState, PhotoProcessedAction action) {
  return GameState.photoProcessed;
}

GameState _retakePhotoReducer(GameState gameState, RetakePhotoAction action) {
  return GameState.takingPhoto;
}

GameState _updateGameStateReducer(GameState gameState, UpdateGameStateAction action) {
  // In case we just removed a tile, but havent reset the values yet
  bool hasInvalidTiles = false;
  action.tileStateMap.forEach((tileKey, tileState) {
    if (tileState.isInvalid) {
      hasInvalidTiles = true;
    }
  });
  Sudoku sudoku = Sudoku(tileStateMap: action.tileStateMap);

  if (hasInvalidTiles) {
    return GameState.invalidTilesPresent;
  } else if (sudoku.isFull() && sudoku.allConstraintsSatisfied()) {
    return GameState.solved;
  } else {
    return GameState.normal;
  }
}

GameState _newGameButtonPressedReducer(GameState gameState, NewGameButtonPressedAction action) {
  return GameState.normal;
}

GameState _gameSolvedReducerReducer(GameState gameState, GameSolvedAction action) {
  return GameState.solved;
}

GameState _changeScreenReducer(GameState gameState, ChangeScreenAction action) {
  if (action.screenState == ScreenState.solveWithCameraScreen) {
    return GameState.takingPhoto;
  }
  return GameState.normal;
}

GameState _stopProcessingPhotoReducer(GameState gameState, StopProcessingPhotoAction action) {
  stopProcessingPhoto();

  return GameState.takingPhoto;
}

GameState _cameraNotLoadedErrorReducer(GameState gameState, CameraNotLoadedErrorAction action) {
  return GameState.cameraNotLoadedError;
}

GameState _processingPhotoErrorReducer(GameState gameState, PhotoProcessingErrorAction action) {
  return GameState.processingPhotoError;
}

GameState _sudokuSolvingTimeoutErrorReducer(GameState gameState, SudokuSolvingTimeoutErrorAction action) {
  return GameState.solvingSudokuTimeoutError;
}

GameState _sudokuSolvingInvalidErrorReducer(GameState gameState, SudokuSolvingInvalidErrorAction action) {
  return GameState.solvingSudokuInvalidError;
}