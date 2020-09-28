import 'package:sudoku_solver_2/algorithm/solver.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

/// Contains all state reducers used by GameState
final Reducer<GameState> gameStateReducer = combineReducers<GameState>([
  TypedReducer<GameState, SolveSudokuAction>(_solveSudokuReducer),
  TypedReducer<GameState, SudokuSolvedAction>(_sudokuSolvedReducer),
  TypedReducer<GameState, CheckIfSolvedAction>(_checkIfSolvedReducer),
  TypedReducer<GameState, GameSolvedAction>(_setToSolved),
  TypedReducer<GameState, RestartAction>(_setToDefault),
  TypedReducer<GameState, TakePhotoAction>(_takePhotoReducer),
  TypedReducer<GameState, PhotoProcessedAction>(_photoProcessedReducer),
  TypedReducer<GameState, RetakePhotoAction>(_retakePhotoReducer),
  TypedReducer<GameState, InvalidTilesPresentAction>(_invalidTilesPresentReducer),
]);

GameState _solveSudokuReducer(GameState gameState, SolveSudokuAction action) {
  Sudoku sudoku = Sudoku(tileStateMap: Redux.store.state.tileStateMap);
  assert(sudoku.tileStateMap.length == 81);

  solveSudokuAsync(sudoku);

  return GameState.isSolving;
}

GameState _sudokuSolvedReducer(GameState gameState, SudokuSolvedAction action) {
  return GameState.solved;
}

GameState _checkIfSolvedReducer(GameState gameState, CheckIfSolvedAction action) {
  int numValues = 0;

  for (TileState tileState in action.tileStateMap.values) {
    if (tileState.value != null) {
      numValues++;
    }
  }

  return (numValues == 81) ? GameState.solved : gameState;
}

GameState _setToSolved(GameState gameState, GameSolvedAction action) {
  return GameState.solved;
}

GameState _setToDefault(GameState gameState, RestartAction action) {
  return GameState.normal;
}

GameState _takePhotoReducer(GameState gameState, TakePhotoAction action) {
  return GameState.processingPhoto;
}

GameState _photoProcessedReducer(GameState gameState, PhotoProcessedAction action) {
  return GameState.photoProcessed;
}

GameState _retakePhotoReducer(GameState gameState, RetakePhotoAction action) {
  return GameState.takingPhoto;
}

GameState _invalidTilesPresentReducer(GameState gameState, InvalidTilesPresentAction action) {
  return GameState.invalidTilesPresent;
}
