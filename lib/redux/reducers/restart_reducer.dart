import 'dart:collection';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

AppState restartReducer(AppState appState, RestartAction action) {
  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();

  appState.tileStateMap.forEach((tileKey, tileState) {
    int value = (tileState.isOriginalTile) ? tileState.value : -1;
    newTileStateMap[tileKey] = tileState.copyWith(value: value, isTapped: false);
  });
  assert(newTileStateMap.length == 81);

  // De-highlight the numbers
  List<NumberState> newNumberStateList = List<NumberState>();
  appState.numberStateList.forEach((numberState) {
    newNumberStateList.add(numberState.copyWith(isActive: false));
  });
  assert(newNumberStateList.length == 9);

  return appState.copyWith(
    tileStateMap: newTileStateMap,
    hasSelectedTile: false,
    numberStateList: newNumberStateList,
    isSolving: false,
  );
}
