import 'dart:collection';
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

/// Fired when a not-currently-pressed tile is pressed
class TileSelectedAction {
  final TileState selectedTile;
  TileSelectedAction(this.selectedTile);
}

/// Fired when a pressed tile is pressed again
class TileDeselectedAction {
  final TileState deselectedTile;
  TileDeselectedAction(this.deselectedTile);
}

/// Fired when a number is pressed while a tile is selected
class NumberPressedAction {
  final NumberState pressedNumber;
  NumberPressedAction(this.pressedNumber);
}

/// Fired to start solving the Sudoku
class SolveSudokuAction {
  SolveSudokuAction();
}

/// Fired once the Sudoku is solved
class SudokuSolvedAction {
  final Sudoku solvedSudoku;
  SudokuSolvedAction(this.solvedSudoku);
}

/// Fired when 'restart' is pressed from the rop down menu
class RestartAction {
  RestartAction();
}

/// Fired when the JustPlayScreen is loaded
class LoadSudokuGameAction {
  final int gameNumber;
  LoadSudokuGameAction(this.gameNumber);
}

/// Fired when the 'new game' button is pressed on the JustPlayScreen
class NewGameButtonPressedAction {
  NewGameButtonPressedAction();
}

class StopSolvingSudokuAction {
  StopSolvingSudokuAction();
}

/// Fired when navigating from one screen to another
class ChangeScreenAction {
  final ScreenState screenState;
  ChangeScreenAction(this.screenState);
}

/// Fired when user takes a photo on the SolveWithCameraScreen
class TakePhotoAction {
  final File imageFile;
  TakePhotoAction(this.imageFile);
}

/// Fired when user is confirming the Sudoku based on their photo on the SolveWithCameraScreen
class VerifyPhotoCreatedSudokuAction {
  final Sudoku constructedSudoku;
  VerifyPhotoCreatedSudokuAction(this.constructedSudoku);
}

/// Fired when a Sudoku is created based on a photo on the SolveWithCameraScreen
class PhotoProcessedAction {
  Sudoku sudoku;
  PhotoProcessedAction(this.sudoku);
}

/// Fired when the user wants to discard their photo and take another
class RetakePhotoAction {
  RetakePhotoAction();
}

/// Fired after a value is added to a tile
class UpdateInvalidTilesAction {
  UpdateInvalidTilesAction();
}

class UpdateGameStateAction {
  final HashMap<TileKey, TileState> tileStateMap;
  UpdateGameStateAction(this.tileStateMap);
}

class ApplyGameStateChangesAction {
  final GameState gameState;
  ApplyGameStateChangesAction(this.gameState);
}

class GameSolvedAction {
  GameSolvedAction();
}

class CameraReadyAction {
  final CameraController cameraController;
  CameraReadyAction(this.cameraController);
}

class StopProcessingPhotoAction {
  StopProcessingPhotoAction();
}

class SetCameraStateProperties {
  final Size screenSize;
  final Rect cameraWidgetBounds;

  SetCameraStateProperties({
    this.screenSize,
    this.cameraWidgetBounds,
  });
}

class CameraNotLoadedErrorAction {
  CameraNotLoadedErrorAction();
}

class PhotoProcessingErrorAction {
  PhotoProcessingErrorAction();
}

class SudokuSolvingTimeoutErrorAction {
  SudokuSolvingTimeoutErrorAction();
}

class SudokuSolvingInvalidErrorAction {
  SudokuSolvingInvalidErrorAction();
}

class ReturnToHomeAction {
  ReturnToHomeAction();
}
