import 'dart:collection';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

AppState sudokuSolvedReducer(AppState appState, SudokuSolvedAction action) {
  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  action.solvedSudoku.tileStateMap.forEach((tileKey, tileState) {
    assert(tileState.value != null);
    assert(1 <= tileState.value && tileState.value <= 9);
    newTileStateMap[tileKey] = tileState.copyWith(value: tileState.value, isTapped: false);
  });

  // Create the new TopText
  TopTextState newTopTextState = appState.topTextState.copyWith(text: MyStrings.topTextSolved, color: MyColors.green);

  return appState.copyWith(
    tileStateMap: newTileStateMap,
    isSolving: false,
    topTextState: newTopTextState,
  );
}
