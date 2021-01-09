part of './constants.dart';

final String tileSelectedSound = 'tile_selected_sound.mp3';
final String tileDeselectedSound = 'tile_deselected_sound.mp3';
final String valueAddedSound = 'value_added_sound.mp3';
final String invalidTilesPresentSound = 'invalid_tiles_present_sound.mp3';
final String buttonPressedSound = 'button_pressed_sound.mp3';
final String gameSolvedSound = 'game_solved_sound.mp3';
final String photoProcessedSound = 'photo_processed_sound.mp3';
final String processingErrorSound = 'processing_error_sound.mp3';

AudioCache _audioCache = AudioCache();

Future<void> loadSoundsToCache() async {
  try {
    await _audioCache.loadAll([
      tileSelectedSound,
      tileDeselectedSound,
      valueAddedSound,
      invalidTilesPresentSound,
      buttonPressedSound,
      gameSolvedSound,
      photoProcessedSound,
      processingErrorSound,
    ]);
  } on Exception catch (e) {
    print(e);
  }
}

Future<void> playSound(String pathToFile) async {
  try {
    await _audioCache.play(pathToFile);
  } on Exception catch (e) {
    print('failed to load sound $pathToFile.  $e');
  }
}
