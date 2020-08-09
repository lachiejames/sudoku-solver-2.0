import 'dart:collection';

import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

HashMap<TileKey, TileState> tilePressedReducer(HashMap<TileKey, TileState> oldTileStateMap, TilePressedAction action) {
  // If any other tiles are pressed, make sure to unpress them
  TileKey alreadyPressedTileKey;
  for (TileState tileState in oldTileStateMap.values) {
    if (tileState.isTapped) {
      alreadyPressedTileKey = TileKey(row: tileState.row, col: tileState.col);
    }
  }

  // Return a new hashmap with the new tile
  HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  TileKey newPressedTileKey = TileKey(row: action.nextPressedTile.row, col: action.nextPressedTile.col);

  for (MapEntry<TileKey, TileState> entry in oldTileStateMap.entries) {
    if (entry.key == newPressedTileKey && entry.value.isTapped == false) {
      newTileStateMap.putIfAbsent(entry.key, () => entry.value.copyWith(isTapped: true));
    } else if (entry.key == alreadyPressedTileKey) {
      newTileStateMap.putIfAbsent(entry.key, () => entry.value.copyWith(isTapped: false));
    } else {
      newTileStateMap.putIfAbsent(entry.key, () => entry.value);
    }
  }
  return newTileStateMap;
}



