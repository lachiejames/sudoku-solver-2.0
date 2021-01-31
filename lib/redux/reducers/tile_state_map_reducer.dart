import 'dart:collection';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

/// Contains all state reducers used by the <TileKey, TileState> map
final Reducer<HashMap<TileKey, TileState>> tileStateMapReducer = combineReducers<
    HashMap<TileKey, TileState>>(<HashMap<TileKey, TileState> Function(HashMap<TileKey, TileState>, dynamic)>[
  TypedReducer<HashMap<TileKey, TileState>, TileSelectedAction>(_tileSelectedReducer),
  TypedReducer<HashMap<TileKey, TileState>, TileDeselectedAction>(_tileDeselectedReducer),
  TypedReducer<HashMap<TileKey, TileState>, LoadSudokuGameAction>(_loadExampleValues),
  TypedReducer<HashMap<TileKey, TileState>, RetakePhotoAction>(_retakePhotoReducer),
  TypedReducer<HashMap<TileKey, TileState>, NumberPressedAction>(_addPressedNumberToTile),
  TypedReducer<HashMap<TileKey, TileState>, SudokuSolvedAction>(_updateTileMapWithSolvedSudokuReducer),
  TypedReducer<HashMap<TileKey, TileState>, RestartAction>(_clearAllValuesReducer),
  TypedReducer<HashMap<TileKey, TileState>, ChangeScreenAction>(_clearTileStateMapReducer),
  TypedReducer<HashMap<TileKey, TileState>, PhotoProcessedAction>(_updateTileMapWithSudokuReducer),
  TypedReducer<HashMap<TileKey, TileState>, UpdateInvalidTilesAction>(_updateInvalidTilesReducer),
  TypedReducer<HashMap<TileKey, TileState>, NewGameButtonPressedAction>(_newGamePressedReducer),
]);

HashMap<TileKey, TileState> _tileSelectedReducer(HashMap<TileKey, TileState> tileStateMap, TileSelectedAction action) {
  // Get tileKey of selected Tile
  final TileKey nextSelectedTileKey = TileKey(row: action.selectedTile.row, col: action.selectedTile.col);

  // Use tileKey to select the tile, in a new tilemap
  tileStateMap.forEach((TileKey tileKey, TileState tileState) {
    final bool isNewlySelectedTile = tileKey == nextSelectedTileKey;
    final bool isOldSelectedTile = tileState.isSelected;

    if (isNewlySelectedTile) {
      tileStateMap[tileKey] = tileState.copyWith(isSelected: true);
    } else if (isOldSelectedTile) {
      tileStateMap[tileKey] = tileState.copyWith(isSelected: false);
    }
  });

  return tileStateMap;
}

HashMap<TileKey, TileState> _tileDeselectedReducer(
    HashMap<TileKey, TileState> tileStateMap, TileDeselectedAction action) {
  assert(action.deselectedTile.isSelected == true);

  // Get tileKey of selected Tile
  final TileKey deselectedTileKey = TileKey(row: action.deselectedTile.row, col: action.deselectedTile.col);

  // Use tileKey to deselect the tile, in a new tilemap
  tileStateMap.forEach((TileKey tileKey, TileState tileState) {
    final bool isDeselectedTile = tileKey == deselectedTileKey;
    final int value = (tileKey == deselectedTileKey) ? -1 : tileState.value;

    if (isDeselectedTile) {
      tileStateMap[tileKey] = tileState.copyWith(isSelected: false, value: value);
    }
  });

  return tileStateMap;
}

HashMap<TileKey, TileState> _loadExampleValues(HashMap<TileKey, TileState> tileStateMap, LoadSudokuGameAction action) {
  final List<List<int>> exampleValues = games[action.gameNumber];

  // clear all values first and originalTiles
  tileStateMap
    ..forEach((TileKey tileKey, TileState tileState) {
      tileStateMap[tileKey] = tileState.copyWith(
        value: -1,
        isOriginalTile: false,
        isInvalid: false,
      );
    })
    ..forEach((TileKey tileKey, TileState tileState) {
      final int value = exampleValues[tileKey.row - 1][tileKey.col - 1];
      final bool isOriginalTile = value != null;
      tileStateMap[tileKey] = tileState.copyWith(
        value: value,
        isOriginalTile: isOriginalTile,
      );
    });

  assert(tileStateMap.length == 81);

  return tileStateMap;
}

HashMap<TileKey, TileState> _addPressedNumberToTile(
    HashMap<TileKey, TileState> tileStateMap, NumberPressedAction action) {
  tileStateMap.forEach((TileKey tileKey, TileState tileState) {
    final bool isSelectedTile = tileState.isSelected;
    final int value = (tileState.isSelected) ? action.pressedNumber.number : tileState.value;

    if (isSelectedTile) {
      tileStateMap[tileKey] = tileState.copyWith(isSelected: false, value: value);
    }
  });

  return tileStateMap;
}

HashMap<TileKey, TileState> _updateTileMapWithSolvedSudokuReducer(
    HashMap<TileKey, TileState> tileStateMap, SudokuSolvedAction action) {
  action.solvedSudoku.tileStateMap.forEach((TileKey tileKey, TileState tileState) {
    assert(tileState.value != null);
    assert(1 <= tileState.value && tileState.value <= 9);
    tileStateMap[tileKey] = tileState.copyWith(value: tileState.value, isSelected: false);
  });

  return tileStateMap;
}

HashMap<TileKey, TileState> _clearAllValuesReducer(HashMap<TileKey, TileState> tileStateMap, RestartAction action) {
  tileStateMap.forEach((TileKey tileKey, TileState tileState) {
    final int value = (tileState.isOriginalTile) ? tileState.value : -1;
    tileStateMap[tileKey] = tileState.copyWith(value: value, isSelected: false, isInvalid: false);
  });

  return tileStateMap;
}

HashMap<TileKey, TileState> _clearTileStateMapReducer(
    HashMap<TileKey, TileState> tileStateMap, ChangeScreenAction action) {
  // Should not clear if looking at help screen
  if (action.screenState != ScreenState.homeScreen) {
    return tileStateMap;
  }

  tileStateMap.forEach((TileKey tileKey, TileState tileState) {
    tileStateMap[tileKey] = tileState.copyWith(value: -1, isSelected: false, isOriginalTile: false, isInvalid: false);
  });

  return tileStateMap;
}

HashMap<TileKey, TileState> _updateTileMapWithSudokuReducer(
    HashMap<TileKey, TileState> tileStateMap, PhotoProcessedAction action) {
  action.sudoku.tileStateMap.forEach((TileKey tileKey, TileState tileState) {
    tileStateMap[tileKey] = tileState.copyWith(value: tileState.value, isSelected: false);
  });

  return tileStateMap;
}

HashMap<TileKey, TileState> _updateInvalidTilesReducer(
    HashMap<TileKey, TileState> tileStateMap, UpdateInvalidTilesAction action) {
  final Sudoku sudoku = Sudoku(tileStateMap: tileStateMap);
  final List<TileKey> invalidTileKeys = sudoku.getInvalidTileKeys();
  bool shouldPlayInvalidTileSound = false;

  tileStateMap.forEach((TileKey tileKey, TileState tileState) {
    if (invalidTileKeys.contains(tileKey) && !tileState.isInvalid) {
      shouldPlayInvalidTileSound = true;
    }
    if (invalidTileKeys.contains(tileKey)) {
      tileStateMap[tileKey] = tileState.copyWith(isInvalid: true);
    } else if (tileState.isInvalid) {
      tileStateMap[tileKey] = tileState.copyWith(isInvalid: false);
    }
  });

  if (shouldPlayInvalidTileSound) {
    playSound(invalidTilesPresentSound);
  } else {
    playSound(tileDeselectedSound);
  }

  return tileStateMap;
}

HashMap<TileKey, TileState> _newGamePressedReducer(
    HashMap<TileKey, TileState> tileStateMap, NewGameButtonPressedAction action) {
  tileStateMap.forEach((TileKey tileKey, TileState tileState) {
    tileStateMap[tileKey] = tileState.copyWith(
      value: -1,
      isSelected: false,
      isOriginalTile: false,
      isInvalid: false,
    );
  });

  return tileStateMap;
}

HashMap<TileKey, TileState> _retakePhotoReducer(HashMap<TileKey, TileState> tileStateMap, RetakePhotoAction action) {
  tileStateMap.forEach((TileKey tileKey, TileState tileState) {
    tileStateMap[tileKey] = tileState.copyWith(
      value: -1,
      isSelected: false,
      isOriginalTile: false,
      isInvalid: false,
    );
  });

  return tileStateMap;
}
