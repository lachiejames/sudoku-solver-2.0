import 'dart:collection';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/my_games.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

final Reducer<HashMap<TileKey, TileState>> tileStateMapReducer = combineReducers<HashMap<TileKey, TileState>>([
  TypedReducer<HashMap<TileKey, TileState>, TileSelectedAction>(_tileSelectedReducer),
  TypedReducer<HashMap<TileKey, TileState>, TileDeselectedAction>(_tileDeselectedReducer),
  TypedReducer<HashMap<TileKey, TileState>, LoadPlayScreenWithSudokuAction>(_loadExampleValues),
  TypedReducer<HashMap<TileKey, TileState>, NumberPressedAction>(_addPressedNumberToTile),
  TypedReducer<HashMap<TileKey, TileState>, SudokuSolvedAction>(_updateTileMapWithSolvedSudokuReducer),
  TypedReducer<HashMap<TileKey, TileState>, RestartAction>(_clearAllValuesReducer),
  TypedReducer<HashMap<TileKey, TileState>, ChangeScreenAction>(_clearTileStateMapReducer),
  TypedReducer<HashMap<TileKey, TileState>, PhotoProcessedAction>(_updateTileMapWithSudokuReducer),
  TypedReducer<HashMap<TileKey, TileState>, CheckForInvalidTilesAction>(_checkForInvalidTilesReducer),
]);

HashMap<TileKey, TileState> _tileSelectedReducer(HashMap<TileKey, TileState> tileStateMap, TileSelectedAction action) {
  // Get tileKey of selected Tile
  final TileKey nextSelectedTileKey = TileKey(row: action.selectedTile.row, col: action.selectedTile.col);

  // Use tileKey to select the tile, in a new tilemap
  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  tileStateMap.forEach((tileKey, tileState) {
    bool isSelected = (tileKey == nextSelectedTileKey);
    newTileStateMap[tileKey] = tileState.copyWith(isSelected: isSelected);
  });

  return newTileStateMap;
}

HashMap<TileKey, TileState> _tileDeselectedReducer(HashMap<TileKey, TileState> tileStateMap, TileDeselectedAction action) {
  assert(action.deselectedTile.isSelected == true);

  // Get tileKey of selected Tile
  final TileKey deselectedTileKey = TileKey(row: action.deselectedTile.row, col: action.deselectedTile.col);

  // Use tileKey to deselect the tile, in a new tilemap
  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  tileStateMap.forEach((tileKey, tileState) {
    int value = (tileKey == deselectedTileKey) ? -1 : tileState.value;
    newTileStateMap[tileKey] = tileState.copyWith(isSelected: false, value: value);
  });

  return newTileStateMap;
}

HashMap<TileKey, TileState> _loadExampleValues(HashMap<TileKey, TileState> tileStateMap, LoadPlayScreenWithSudokuAction action) {
  final List<List<int>> exampleValues = MyGames.games[action.gameNumber];

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
    int value = (tileState.isSelected) ? action.pressedNumber.number : tileState.value;
    newTileStateMap[tileKey] = tileState.copyWith(value: value, isSelected: false);
  });

  return newTileStateMap;
}

HashMap<TileKey, TileState> _updateTileMapWithSolvedSudokuReducer(HashMap<TileKey, TileState> tileStateMap, SudokuSolvedAction action) {
  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  action.solvedSudoku.tileStateMap.forEach((tileKey, tileState) {
    assert(tileState.value != null);
    assert(1 <= tileState.value && tileState.value <= 9);
    newTileStateMap[tileKey] = tileState.copyWith(value: tileState.value, isSelected: false);
  });

  return newTileStateMap;
}

HashMap<TileKey, TileState> _clearAllValuesReducer(HashMap<TileKey, TileState> tileStateMap, RestartAction action) {
  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  tileStateMap.forEach((tileKey, tileState) {
    int value = (tileState.isOriginalTile) ? tileState.value : -1;
    newTileStateMap[tileKey] = tileState.copyWith(value: value, isSelected: false, isInvalid: false);
  });

  return newTileStateMap;
}

HashMap<TileKey, TileState> _clearTileStateMapReducer(HashMap<TileKey, TileState> tileStateMap, ChangeScreenAction action) {
  // Should not clear if looking at help screen
  if (action.screenState != ScreenState.HomeScreen) {
    return tileStateMap;
  }

  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  tileStateMap.forEach((tileKey, tileState) {
    newTileStateMap[tileKey] = tileState.copyWith(value: -1, isSelected: false, isOriginalTile: false, isInvalid: false);
  });

  return newTileStateMap;
}

HashMap<TileKey, TileState> _updateTileMapWithSudokuReducer(HashMap<TileKey, TileState> tileStateMap, PhotoProcessedAction action) {
  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  action.sudoku.tileStateMap.forEach((tileKey, tileState) {
    newTileStateMap[tileKey] = tileState.copyWith(value: tileState.value, isSelected: false);
  });

  return newTileStateMap;
}

HashMap<TileKey, TileState> _checkForInvalidTilesReducer(HashMap<TileKey, TileState> tileStateMap, CheckForInvalidTilesAction action) {
  // In case we just removed a tile, but havent reset the values yet
  bool hasInvalidTiles = false;
  tileStateMap.forEach((tileKey, tileState) {
    if (tileState.isInvalid) {
      hasInvalidTiles = true;
    }
   });
  Sudoku sudoku = Sudoku(tileStateMap: tileStateMap);

  if (sudoku.allConstraintsSatisfied() && !hasInvalidTiles) {
    return tileStateMap;
  } else {
    final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
    final List<TileKey> invalidTileKeys = sudoku.getInvalidTileKeys();
    tileStateMap.forEach((tileKey, tileState) {
      bool isInvalid = invalidTileKeys.contains(tileKey);
      newTileStateMap[tileKey] = tileState.copyWith(isInvalid: isInvalid);
    });

    Redux.store.dispatch(InvalidTilesPresentAction());

    return newTileStateMap;
  }
}
