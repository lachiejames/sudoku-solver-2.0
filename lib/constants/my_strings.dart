/// Stores some strings used within the app
part of './constants.dart';

// Screen names
const String solveWithCameraScreenName = 'Camera';
const String solveWithTouchScreenName = 'Touch';
const String justPlayScreenName = 'Play';
const String helpScreenName = 'Help';

// TopText
const String topTextHome = 'Choose a solving method';
const String topTextNoTileSelected = 'Pick a tile';
const String topTextTileSelected = 'Pick a number';
const String topTextTileWithValueSelected = 'Tap to remove';
const String topTextTakingPhoto = 'Align with camera';
const String topTextWhenSolving = 'AI thinking...';
const String topTextSolved = 'SOLVED';
const String topTextConstructingSudoku = 'Constructing Sudoku...';
const String topTextVerifySudoku = 'Is this your Sudoku?';
const String topTextCameraNotFoundError = 'Camera not found';
const String topTextPhotoProcessingError = 'Unable to generate Sudoku';
const String topTextSudokuInvalidError = 'Cannot solve, Sudoku is invalid';
const String topTextSolvingTimeoutError = 'The A.I. timed out';

const String topTextWhenNoSolutionFound = 'NO SOLUTION';

// DropDownMenu options
const String dropDownMenuOption1 = 'Restart';
const String dropDownMenuOption2 = 'Help';

// Button text
const String solveWithCameraButtonText = 'CAMERA';
const String solveWithTouchButtonText = 'TOUCH';
const String justPlayButtonText = 'JUST PLAY';
const String takePhotoButtonText = 'TAKE PHOTO';
const String retakePhotoButtonText = 'RETAKE PHOTO';
const String solveSudokuButtonText = 'SOLVE SUDOKU';
const String stopSolvingButtonText = 'STOP';
const String topTextStopConstructingSudoku = 'STOP';
const String newGameButtonText = 'NEW GAME';
const String restartButtonText = 'RESTART';
const String returnToHomeText = 'RETURN TO HOME';

// Set to null when running all tests
const String dartVMServiceUrl = 'http://127.0.0.1:8888/';

const String gameNumberSharedPrefsKey = 'sudoku_solver_game_number';
