import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';

/// Combines all state into a single class, to be used in Redux
@immutable
class AppState {
  final HashMap<TileKey, TileState> tileStateMap;
  final List<NumberState> numberStateList;
  final TopTextState topTextState;
  final int gameNumber;
  final ScreenState screenState;
  final GameState gameState;
  final CameraState cameraState;

  AppState({
    @required this.tileStateMap,
    @required this.numberStateList,
    @required this.topTextState,
    @required this.gameNumber,
    @required this.screenState,
    @required this.gameState,
    @required this.cameraState,
  });

  AppState copyWith({
    HashMap<TileKey, TileState> tileStateMap,
    List<NumberState> numberStateList,
    TopTextState topTextState,
    int gameNumber,
    ScreenState screenState,
    GameState gameState,
    CameraState cameraState,
  }) {
    return AppState(
      tileStateMap: tileStateMap ?? this.tileStateMap,
      numberStateList: numberStateList ?? this.numberStateList,
      topTextState: topTextState ?? this.topTextState,
      gameNumber: gameNumber ?? this.gameNumber,
      screenState: screenState ?? this.screenState,
      gameState: gameState ?? this.gameState,
      cameraState: cameraState ?? this.cameraState,
    );
  }
}
