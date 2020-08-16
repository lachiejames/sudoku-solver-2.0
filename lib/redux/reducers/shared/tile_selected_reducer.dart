import 'dart:collection';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

AppState tileSelectedReducer(AppState appState, TileSelectedAction action) {
  final TileState nextSelectedTile = action.selectedTile;
  assert(nextSelectedTile != null);
  final TileKey nextSelectedTileKey = TileKey(row: nextSelectedTile.row, col: nextSelectedTile.col);

  final HashMap<TileKey, TileState> newTileStateMap = HashMap.from(appState.tileStateMap);
  newTileStateMap[nextSelectedTileKey] = nextSelectedTile.copyWith(isTapped: true);
  assert(newTileStateMap.length == 81);

  // deselect old tile if applicable
  if (appState.hasSelectedTile) {
    final TileKey prevSelectedTileKey = MyWidgets.extractSelectedTileKey(appState.tileStateMap);
    newTileStateMap[prevSelectedTileKey] = newTileStateMap[prevSelectedTileKey].copyWith(isTapped: false);
    assert(newTileStateMap[prevSelectedTileKey] != null);
  }

  // Highlight the numbers
  List<NumberState> newNumberStateList = List<NumberState>();
  appState.numberStateList.forEach((numberState) {
    newNumberStateList.add(numberState.copyWith(isActive: true));
  });
  assert(newNumberStateList.length == 9);

  // Create the new TopText
  TopTextState newTopTextState;
  if (action.selectedTile.value != null) {
    newTopTextState = appState.topTextState.copyWith(text: MyStrings.topTextTapToRemove, color: MyColors.white);
  } else {
    newTopTextState = appState.topTextState.copyWith(text: MyStrings.topTextPickANumber, color: MyColors.white);
  }

  return appState.copyWith(
    tileStateMap: newTileStateMap,
    hasSelectedTile: true,
    numberStateList: newNumberStateList,
    topTextState: newTopTextState,
  );
}
