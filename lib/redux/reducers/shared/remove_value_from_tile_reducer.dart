import 'dart:collection';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

AppState removeValueFromTileReducer(AppState appState, RemoveValueFromTileAction action) {
  assert(appState.hasSelectedTile);
  assert(action.selectedTile.value != null);

  final TileState selectedTile = action.selectedTile;
  final TileKey selectedTileKey = TileKey(row: selectedTile.row, col: selectedTile.col);

  final HashMap<TileKey, TileState> newTileStateMap = HashMap.from(appState.tileStateMap);
  newTileStateMap[selectedTileKey] = selectedTile.copyWith(isTapped: false, value: -1);

  // De-highlight the numbers
  List<NumberState> newNumberStateList = List<NumberState>();
  appState.numberStateList.forEach((numberState) {
    newNumberStateList.add(numberState.copyWith(isActive: false));
  });

  // Create the new TopText
  TopTextState newTopTextState = appState.topTextState.copyWith(text: MyStrings.topTextPickATile, color: MyColors.white);

  return appState.copyWith(
    tileStateMap: newTileStateMap,
    hasSelectedTile: false,
    numberStateList: newNumberStateList,
    topTextState: newTopTextState,
    isSolved: false,
  );
}
