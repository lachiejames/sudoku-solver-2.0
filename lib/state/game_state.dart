/// Represents what is currently happening within the app
enum GameState {
  normal,
  invalidTilesPresent,
  isSolving,
  solved,
  takingPhoto,
  processingPhoto,
  photoProcessed,
  cameraNotLoadedError,
  processingPhotoError,
  solvingSudokuTimeoutError,
  solvingSudokuInvalidError,
}
