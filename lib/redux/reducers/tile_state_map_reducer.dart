import 'dart:collection';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/my_games.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

final Reducer<HashMap<TileKey, TileState>> tileStateMapReducer = combineReducers<HashMap<TileKey, TileState>>([
  TypedReducer<HashMap<TileKey, TileState>, TileSelectedAction>(_tileSelectedReducer),
  TypedReducer<HashMap<TileKey, TileState>, TileDeselectedAction>(_tileDeselectedReducer),
  TypedReducer<HashMap<TileKey, TileState>, RemoveValueFromTileAction>(_removeValueFromTileReducer),
  TypedReducer<HashMap<TileKey, TileState>, LoadPlayScreenWithSudokuAction>(_loadExampleValues),
  TypedReducer<HashMap<TileKey, TileState>, NumberPressedAction>(_addPressedNumberToTile),
  TypedReducer<HashMap<TileKey, TileState>, SudokuSolvedAction>(_updateTileMapWithSolvedSudokuReducer),
  TypedReducer<HashMap<TileKey, TileState>, RestartAction>(_clearAllValuesReducer),
]);

HashMap<TileKey, TileState> _tileSelectedReducer(HashMap<TileKey, TileState> tileStateMap, TileSelectedAction action) {
  // Get tileKey of selected Tile
  final TileState nextSelectedTile = action.selectedTile;
  assert(nextSelectedTile != null);
  final TileKey nextSelectedTileKey = TileKey(row: nextSelectedTile.row, col: nextSelectedTile.col);

  // Use tileKey to select the tile, in a new tilemap
  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  tileStateMap.forEach((tileKey, tileState) {
    if (tileKey == nextSelectedTileKey) {
      newTileStateMap[tileKey] = tileState.copyWith(isTapped: true);
    } else {
      newTileStateMap[tileKey] = tileState.copyWith(isTapped: false);
    }
  });

  return newTileStateMap;
}

HashMap<TileKey, TileState> _tileDeselectedReducer(HashMap<TileKey, TileState> tileStateMap, TileDeselectedAction action) {
  assert(action.deselectedTile.value == null);

  // Get tileKey of selected Tile
  final TileState deselectedTile = action.deselectedTile;
  final TileKey deselectedTileKey = TileKey(row: deselectedTile.row, col: deselectedTile.col);

  // Use tileKey to deselect the tile, in a new tilemap
  final HashMap<TileKey, TileState> newTileStateMap = HashMap.from(tileStateMap);
  newTileStateMap[deselectedTileKey] = deselectedTile.copyWith(isTapped: false);

  return newTileStateMap;
}

HashMap<TileKey, TileState> _removeValueFromTileReducer(HashMap<TileKey, TileState> tileStateMap, RemoveValueFromTileAction action) {
  assert(action.selectedTile.value != null);

  // Get tileKey of selected Tile
  final TileState selectedTile = action.selectedTile;
  final TileKey selectedTileKey = TileKey(row: selectedTile.row, col: selectedTile.col);

  // Use tileKey to deselect the tile and remove its value, in a new tilemap
  final HashMap<TileKey, TileState> newTileStateMap = HashMap.from(tileStateMap);
  newTileStateMap[selectedTileKey] = selectedTile.copyWith(isTapped: false, value: -1);

  return newTileStateMap;
}

HashMap<TileKey, TileState> _loadExampleValues(HashMap<TileKey, TileState> tileStateMap, LoadPlayScreenWithSudokuAction action) {
  final List<List<int>> exampleValues = MyGames.games[0];

  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  tileStateMap.forEach((tileKey, tileState) {
    int value = exampleValues[tileKey.row - 1][tileKey.col - 1];
    bool isOriginalTile = (value != null);
    newTileStateMap[tileKey] = tileState.copyWith(value: value, isOriginalTile: isOriginalTile);
  });

  assert(newTileStateMap.length == 81);

  return newTileStateMap;
}

HashMap<TileKey, TileState> _addPressedNumberToTile(HashMap<TileKey, TileState> tileStateMap, NumberPressedAction action) {
  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();

  tileStateMap.forEach((tileKey, tileState) {
    if (tileState.isTapped) {
      newTileStateMap[tileKey] = tileState.copyWith(value: action.pressedNumber.number, isTapped: false);
    } else {
      newTileStateMap[tileKey] = tileState.copyWith(isTapped: false);
    }
  });

  return newTileStateMap;
}

HashMap<TileKey, TileState> _updateTileMapWithSolvedSudokuReducer(HashMap<TileKey, TileState> tileStateMap, SudokuSolvedAction action) {
  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  action.solvedSudoku.tileStateMap.forEach((tileKey, tileState) {
    assert(tileState.value != null);
    assert(1 <= tileState.value && tileState.value <= 9);
    newTileStateMap[tileKey] = tileState.copyWith(value: tileState.value, isTapped: false);
  });

  return newTileStateMap;
}

HashMap<TileKey, TileState> _clearAllValuesReducer(HashMap<TileKey, TileState> tileStateMap, RestartAction action) {
  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  tileStateMap.forEach((tileKey, tileState) {
    int value = (tileState.isOriginalTile) ? tileState.value : -1;
    newTileStateMap[tileKey] = tileState.copyWith(value: value, isTapped: false);
  });

  return newTileStateMap;
}
