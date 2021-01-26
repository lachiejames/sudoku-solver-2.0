/// Stores some strings used within the app
part of './constants.dart';

// Screen names
final String solveWithCameraScreenName = 'Camera';
final String solveWithTouchScreenName = 'Touch';
final String justPlayScreenName = 'Play';
final String helpScreenName = 'Help';

// TopText
final String topTextHome = 'How would you like it to be solved?';
final String topTextNoTileSelected = 'Pick a tile';
final String topTextTileSelected = 'Pick a number';
final String topTextTileWithValueSelected = 'Tap to remove';
final String topTextTakingPhoto = 'Align with camera';
final String topTextWhenSolving = 'AI thinking...';
final String topTextSolved = 'SOLVED';
final String topTextConstructingSudoku = 'Constructing Sudoku...';
final String topTextStopConstructingSudoku = 'STOP CONSTRUCTING';
final String topTextVerifySudoku = 'Is this your Sudoku?';
final String topTextCameraNotFoundError = 'Camera not found';
final String topTextPhotoProcessingError = 'Unable to generate Sudoku';
final String topTextSudokuInvalidError = 'Cannot solve, Sudoku is invalid';
final String topTextSolvingTimeoutError = 'The A.I. timed out';

final String topTextWhenNoSolutionFound = 'NO SOLUTION';

// DropDownMenu options
final String dropDownMenuOption1 = 'Restart';
final String dropDownMenuOption2 = 'Help';

// Button text
final String solveWithCameraButtonText = 'SOLVE WITH CAMERA';
final String solveWithTouchButtonText = 'SOLVE WITH TOUCH';
final String justPlayButtonText = 'JUST PLAY';
final String takePhotoButtonText = 'TAKE PHOTO';
final String retakePhotoButtonText = 'RETAKE PHOTO';
final String solveSudokuButtonText = 'SOLVE SUDOKU';
final String stopSolvingButtonText = 'STOP SOLVING';
final String newGameButtonText = 'NEW GAME';
final String restartButtonText = 'RESTART';
final String returnToHomeText = 'RETURN TO HOME';

// Set to null when running all tests
final String dartVMServiceUrl = 'http://127.0.0.1:8888/';

final String gameNumberSharedPrefsKey = 'sudoku_solver_game_number';
