import 'package:sudoku_solver_2/algorithm/solver.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:redux/redux.dart';

final Reducer<GameState> gameStateReducer = combineReducers<GameState>([
  TypedReducer<GameState, SolveSudokuAction>(_solveSudokuReducer),
  TypedReducer<GameState, SudokuSolvedAction>(_sudokuSolvedReducer),
  TypedReducer<GameState, NumberPressedAction>(_setToSolvedIfAllTilesFilled),
  TypedReducer<GameState, GameSolvedAction>(_setToSolved),
  TypedReducer<GameState, RestartAction>(_setToDefault),
  TypedReducer<GameState, PhotoProcessedAction>(_photoProcessedReducer),
  TypedReducer<GameState, RetakePhotoAction>(_retakePhotoReducer),
  TypedReducer<GameState, InvalidTilesPresentAction>(_invalidTilesPresentReducer),
]);

GameState _solveSudokuReducer(GameState gameState, SolveSudokuAction action) {
  Sudoku sudoku = Sudoku(tileStateMap: Redux.store.state.tileStateMap);
  assert(sudoku.tileStateMap.length == 81);

  solveSudokuAsync(sudoku);

  return GameState.IsSolving;
}

GameState _sudokuSolvedReducer(GameState gameState, SudokuSolvedAction action) {
  return GameState.Solved;
}

GameState _setToSolvedIfAllTilesFilled(GameState gameState, NumberPressedAction action) {
  int numValues = 0;
  Redux.store.state.tileStateMap.forEach((tileKey, tileState) {
    if (tileState.value != null) {
      numValues++;
    }
  });
  GameState newGameState = (numValues == 81) ? GameState.Solved : gameState;
  if (newGameState == GameState.Solved) {
    // Redux.store.dispatch(GameSolvedAction());
  }
  return newGameState;
}

GameState _setToSolved(GameState gameState, GameSolvedAction action) {
  return GameState.Solved;
}

GameState _setToDefault(GameState gameState, RestartAction action) {
  return GameState.Default;
}

GameState _photoProcessedReducer(GameState gameState, PhotoProcessedAction action) {
  return GameState.PhotoProcessed;
}

GameState _retakePhotoReducer(GameState gameState, RetakePhotoAction action) {
  return GameState.TakingPhoto;
}

GameState _invalidTilesPresentReducer(GameState gameState, InvalidTilesPresentAction action) {
  return GameState.InvalidTilesPresent;
}
