import 'package:camera/camera.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

class TileSelectedAction {
  final TileState selectedTile;

  TileSelectedAction(this.selectedTile);
}

class TileDeselectedAction {
  final TileState deselectedTile;

  TileDeselectedAction(this.deselectedTile);
}

class NumberPressedAction {
  final NumberState pressedNumber;

  NumberPressedAction(this.pressedNumber);
}

class SolveSudokuAction {
  SolveSudokuAction();
}

class SudokuSolvedAction {
  final Sudoku solvedSudoku;

  SudokuSolvedAction(this.solvedSudoku);
}

class RestartAction {
  RestartAction();
}

class LoadPlayScreenWithSudokuAction {
  final int gameNumber;
  LoadPlayScreenWithSudokuAction(this.gameNumber);
}

class NewGameButtonPressedAction {
  NewGameButtonPressedAction();
}

class GameSolvedAction {
  GameSolvedAction();
}

class ChangeScreenAction {
  final ScreenState screenState;
  ChangeScreenAction(this.screenState);
}

class VerifyPhotoCreatedSudokuAction {
  final Sudoku constructedSudoku;
  VerifyPhotoCreatedSudokuAction(this.constructedSudoku);
}
class TakePhotoAction {
  TakePhotoAction();
}

class PhotoProcessedAction {
  Sudoku sudoku;
  PhotoProcessedAction(this.sudoku);
}

class RetakePhotoAction {
  RetakePhotoAction();
}

class CheckForInvalidTilesAction {
  CheckForInvalidTilesAction();
}

class InvalidTilesPresentAction {
  InvalidTilesPresentAction();
}
class ProcessPhotoAction {
  final CameraController cameraController;
  ProcessPhotoAction(this.cameraController);
}
