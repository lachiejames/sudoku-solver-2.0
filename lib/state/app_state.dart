import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

@immutable
class AppState {
  final HashMap<TileKey, TileState> tileStateMap;
  final bool hasSelectedTile;
  final List<NumberState> numberStateList;
  final TopTextState topTextState;
  final bool isSolving;
  final bool isSolved;

  AppState({
    @required this.tileStateMap,
    @required this.hasSelectedTile,
    @required this.numberStateList,
    @required this.topTextState,
    @required this.isSolving,
    @required this.isSolved,
  });

  AppState copyWith({
    HashMap<TileKey, TileState> tileStateMap,
    bool hasSelectedTile,
    List<NumberState> numberStateList,
    TopTextState topTextState,
    bool isSolving,
    bool isSolved,
  }) {
    return AppState(
      tileStateMap: tileStateMap ?? this.tileStateMap,
      hasSelectedTile: hasSelectedTile ?? this.hasSelectedTile,
      numberStateList: numberStateList ?? this.numberStateList,
      topTextState: topTextState ?? this.topTextState,
      isSolving: isSolving ?? this.isSolving,
      isSolved: isSolved ?? this.isSolved,
    );
  }
}