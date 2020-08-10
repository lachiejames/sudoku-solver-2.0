import 'dart:collection';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

AppState solveButtonPressedReducer(AppState appState, SolveButtonPressedAction action) {
  final HashMap<TileKey, TileState> newTileStateMap = HashMap.from(appState.tileStateMap);

  return appState.copyWith(
    tileStateMap: newTileStateMap,
  );
}