import 'dart:collection';

import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

HashMap<TileKey, TileState> tilePressedReducer(HashMap<TileKey, TileState> oldTileStateMap, TilePressedAction action) {
  print('tilePressedReducer');
  print(action.tileState);
  HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  TileKey pressedTileKey = TileKey(row: action.tileState.row, col: action.tileState.col);

  for (MapEntry<TileKey, TileState> entry in oldTileStateMap.entries) {
    if (entry.key == pressedTileKey) {
      newTileStateMap.putIfAbsent(entry.key, () => entry.value.copyWith(isTapped: true));
    } else {
      newTileStateMap.putIfAbsent(entry.key, () => entry.value);
    }
  }
  return newTileStateMap;
}
