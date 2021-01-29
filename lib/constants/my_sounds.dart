part of './constants.dart';

const String tileSelectedSound = 'tile_selected_sound.mp3';
const String tileDeselectedSound = 'tile_deselected_sound.mp3';
const String invalidTilesPresentSound = 'invalid_tiles_present_sound.mp3';
const String buttonPressedSound = 'button_pressed_sound.mp3';
const String gameSolvedSound = 'game_solved_sound.mp3';
const String photoProcessedSound = 'photo_processed_sound.mp3';
const String processingErrorSound = 'processing_error_sound.mp3';

AudioCache _audioCache = AudioCache();

Future<void> loadSoundsToCache() async {
  try {
    await _audioCache.loadAll(<String>[
      tileSelectedSound,
      tileDeselectedSound,
      invalidTilesPresentSound,
      buttonPressedSound,
      gameSolvedSound,
      photoProcessedSound,
      processingErrorSound,
    ]);
    // Ignore warning because this throws a FlutterError instead of an Exception
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    await logError('ERROR: sound could not be loaded', e);
  }
}

Future<void> playSound(String pathToFile) async {
  try {
    await _audioCache.play(pathToFile);
  } on Exception catch (e) {
    await logError('ERROR: failed to load sound $pathToFile', e);
  }
}
