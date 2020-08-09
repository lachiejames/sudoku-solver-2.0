import 'dart:collection';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/store.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

AppState tileSelectedReducer(AppState appState, TileSelectedAction action) {
  final TileState nextSelectedTile = action.selectedTile.copyWith(isTapped: true);
  final TileKey nextSelectedTileKey = TileKey(row: nextSelectedTile.row, col: nextSelectedTile.col);

  final HashMap<TileKey, TileState> newTileStateMap = HashMap.from(appState.tileStateMap);
  newTileStateMap[nextSelectedTileKey] = nextSelectedTile;

  // deselect old tile if applicable
  if (appState.selectedTile != null) {
    final TileKey prevSelectedTileKey = TileKey(row: appState.selectedTile.row, col: appState.selectedTile.col);
    newTileStateMap[prevSelectedTileKey] = appState.selectedTile.copyWith(isTapped: false);
  }

  // Highlight the numbers
  List<NumberState> newNumberStateList = List<NumberState>();
  appState.numberStateList.forEach((numberState) {
    newNumberStateList.add(numberState.copyWith(isActive: true));
  });

  return appState.copyWith(
    tileStateMap: newTileStateMap,
    selectedTile: nextSelectedTile,
    numberStateList: newNumberStateList,
  );
}

AppState tileDeselectedReducer(AppState appState, TileDeselectedAction action) {
  final TileState deselectedTile = action.deselectedTile.copyWith(isTapped: false);
  final TileKey deselectedTileKey = TileKey(row: deselectedTile.row, col: deselectedTile.col);

  final HashMap<TileKey, TileState> newTileStateMap = HashMap.from(appState.tileStateMap);
  newTileStateMap[deselectedTileKey] = deselectedTile;

  // De-highlight the numbers
  List<NumberState> newNumberStateList = List<NumberState>();
  appState.numberStateList.forEach((numberState) {
    newNumberStateList.add(numberState.copyWith(isActive: false));
  });

  return appState.copyWith(
    tileStateMap: newTileStateMap,
    selectedTile: null,
    numberStateList: newNumberStateList,
  );
}
