import 'dart:collection';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

AppState numberPressedReducer(AppState appState, NumberPressedAction action) {
  assert(appState.hasSelectedTile);

  final TileKey selectedTileKey = MyWidgets.extractSelectedTileKey(appState.tileStateMap);
  final TileState selectedTile = appState.tileStateMap[selectedTileKey];

  final HashMap<TileKey, TileState> newTileStateMap = HashMap.from(appState.tileStateMap);
  newTileStateMap[selectedTileKey] = selectedTile.copyWith(value: action.pressedNumber.number, isTapped: false);

  // De-highlight the numbers
  List<NumberState> newNumberStateList = List<NumberState>();
  appState.numberStateList.forEach((numberState) {
    newNumberStateList.add(numberState.copyWith(isActive: false));
  });

  return appState.copyWith(
    tileStateMap: newTileStateMap,
    hasSelectedTile: false,
    numberStateList: newNumberStateList,
  );
}
