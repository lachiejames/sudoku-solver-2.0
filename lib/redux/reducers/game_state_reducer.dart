import 'package:sudoku_solver_2/algorithm/solver.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:redux/redux.dart';

final Reducer<GameState> gameStateReducer = combineReducers<GameState>([
  TypedReducer<GameState, SolveButtonPressedAction>(_solveButtonPressedReducer),
  TypedReducer<GameState, StartSolvingSudokuAction>(_startSolvingSudokuReducer),
  TypedReducer<GameState, SudokuSolvedAction>(_sudokuSolvedReducer),
  TypedReducer<GameState, NumberPressedAction>(_setToSolvedIfAllTilesFilled),
  TypedReducer<GameState, GameSolvedAction>(_setToSolved),
]);

GameState _solveButtonPressedReducer(GameState gameState, SolveButtonPressedAction action) {
  // This makes the function not pure unfortunately
  Redux.store.dispatch(StartSolvingSudokuAction());

  return GameState.IsSolving;
}

GameState _startSolvingSudokuReducer(GameState gameState, StartSolvingSudokuAction action) {
  Sudoku sudoku = Sudoku(tileStateMap: Redux.store.state.tileStateMap);
  assert(sudoku.tileStateMap.length == 81);

  // This makes the function not pure unfortunately
  solveSudokuAsync(sudoku).then((solvedSudoku) {
    assert(solvedSudoku.tileStateMap.length == 81);
    assert(solvedSudoku.isFull());
    assert(solvedSudoku.allConstraintsSatisfied());
    Redux.store.dispatch(
      SudokuSolvedAction(solvedSudoku),
    );
  });

  return gameState;
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
    Redux.store.dispatch(GameSolvedAction());
  }
  return newGameState;
}

GameState _setToSolved(GameState gameState, GameSolvedAction action) {
  return GameState.Solved;
}
