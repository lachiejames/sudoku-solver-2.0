import 'dart:collection';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

AppState tileDeselectedReducer(AppState appState, TileDeselectedAction action) {
  assert(appState.hasSelectedTile);
  assert(action.deselectedTile.value == null);

  final TileState deselectedTile = action.deselectedTile;
  final TileKey deselectedTileKey = TileKey(row: deselectedTile.row, col: deselectedTile.col);

  final HashMap<TileKey, TileState> newTileStateMap = HashMap.from(appState.tileStateMap);
  newTileStateMap[deselectedTileKey] = deselectedTile.copyWith(isTapped: false);

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
  );
}
