import 'dart:collection';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

AppState sudokuSolvedReducer(AppState appState, SudokuSolvedAction action) {

  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  action.solvedSudoku.tileStateMap.forEach((tileKey, tileState) {
    newTileStateMap.putIfAbsent(tileKey, () => tileState.copyWith());
  });

  return appState.copyWith(
    tileStateMap: newTileStateMap,
    isSolving: false,
  );
}
