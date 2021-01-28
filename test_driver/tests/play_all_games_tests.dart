@Skip('play-all-games integration test')

import 'package:test/test.dart';

import '../utils/games.dart';
import '../utils/shared.dart';
import '../utils/solved_games.dart' as my_solved_games;

void main() {
  group('JustPlayScreenAllGames tests ->', () {
    setUpAll(() async {
      await initTests();
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    setUp(() async {
      await hotRestart();
      await navigateToJustPlayScreen();
    });

    test('can play all 10 games in a row', () async {
      for (int i = 0; i < my_solved_games.solvedGamesList.length; i++) {
        await playGame(my_solved_games.solvedGamesList[i]);
        await tapNewGameButton();
      }

      // After all games are finished, it rounds back to the first game
      await verifyInitialGameTiles(games[0]);
    }, timeout: longTimeout);
  });
}
