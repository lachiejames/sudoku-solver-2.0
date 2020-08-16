import 'dart:collection';

import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_games.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

AppState newGameButtonPressedReducer(AppState appState, NewGameButtonPressedAction action) {
  Redux.store.dispatch(StartSolvingSudokuAction());

  // proceed to the next game, using % to prevent index error
  final int newGameNumber = (appState.gameNumber + 1) % MyGames.games.length;
  final List<List<int>> exampleValues = MyGames.games[newGameNumber];

  final HashMap<TileKey, TileState> newTileStateMap = HashMap<TileKey, TileState>();
  appState.tileStateMap.forEach((tileKey, tileState) {
    int value = exampleValues[tileKey.row - 1][tileKey.col - 1];
    bool isOriginalTile = (value != null);
    newTileStateMap[tileKey] = tileState.copyWith(value: value, isOriginalTile: isOriginalTile, isTapped: false);
  });

  assert(newTileStateMap.length == 81);

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
    isSolving: false,
    isSolved: false,
    gameNumber: newGameNumber,
  );
}
