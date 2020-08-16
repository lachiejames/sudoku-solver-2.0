import 'dart:collection';
import 'package:sudoku_solver_2/constants/my_games.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

AppState loadPlayScreenWithSudokuReducer(AppState appState, LoadPlayScreenWithSudokuAction action) {
  assert(appState.hasSelectedTile == false);
  assert(appState.isSolving == false);

  final List<List<int>> exampleValues = MyGames.games[appState.gameNumber];

  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  appState.tileStateMap.forEach((tileKey, tileState) {
    int value = exampleValues[tileKey.row - 1][tileKey.col - 1];
    bool isOriginalTile = (value != null);
    newTileStateMap[tileKey] = tileState.copyWith(value: value, isOriginalTile: isOriginalTile);
  });

  assert(newTileStateMap.length == 81);

  return appState.copyWith(
    tileStateMap: newTileStateMap,
  );
}
