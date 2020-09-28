@Skip('play-all-games integration test')

import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_games.dart' as my_games;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:test/test.dart';

import 'my_solved_games.dart' as my_solved_games;
import 'shared.dart';

void main() async {
  FlutterDriver driver;

  setUpAll(() async {
    await grantAppPermissions();
    driver = await FlutterDriver.connect(dartVmServiceUrl: my_strings.dartVMServiceUrl);

    await driver.requestData(my_strings.hotRestart);
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
  });

  group('JustPlayScreenAllGames tests ->', () {
    void navigateToJustPlayScreen() async {
      await driver.tap(find.text(my_strings.justPlayButtonText));
      await driver.waitUntilNoTransientCallbacks();
      await driver.getText(find.text(my_strings.topTextNoTileSelected));
    }

    void tapTile(TileKey tileKey) async {
      await driver.tap(find.byValueKey('${tileKey.toString()}'));
      await driver.waitUntilNoTransientCallbacks();
    }

    void tapNumber(int number) async {
      await driver.tap(find.byValueKey('Number($number)'));
      await driver.waitUntilNoTransientCallbacks();
    }

    void addNumberToTile(int number, TileKey tileKey) async {
      await tapTile(tileKey);
      await tapNumber(number);
    }

    void tapNewGameButton() async {
      await driver.tap(find.text('NEW GAME'));
      await driver.waitUntilNoTransientCallbacks();
    }

    Future<int> getNumberOnTile(TileKey tileKey) async {
      String tileText = await driver.getText(await find.byValueKey('${tileKey.toString()}_text'));

      if (tileText == "") {
        return null;
      } else {
        return int.parse(tileText);
      }
    }

    void expectNumberOnTileToBe(int number, TileKey tileKey) async {
      int numberOnTile = await getNumberOnTile(tileKey);
      expect(numberOnTile == number, true);
    }

    // Restart app at beginning of each test
    setUp(() async {
      await driver.requestData(my_strings.hotRestart);
      await navigateToJustPlayScreen();
    });

    group('playing a game ->', () {
      Future<void> verifyInitialGameTiles(List<List<int>> game) async {
        for (int row = 1; row <= 9; row++) {
          for (int col = 1; col <= 9; col++) {
            await expectNumberOnTileToBe(game[row - 1][col - 1], TileKey(row: row, col: col));
          }
        }
      }

      Future<void> playGame(List<List<int>> game) async {
        for (int row = 1; row <= 9; row++) {
          for (int col = 1; col <= 9; col++) {
            if (await getNumberOnTile(TileKey(row: row, col: col)) == null) {
              await addNumberToTile(game[row - 1][col - 1], TileKey(row: row, col: col));
              await driver.waitUntilNoTransientCallbacks();
            }
          }
        }
      }

      test('can play all 10 games in a row', () async {
        await verifyInitialGameTiles(my_games.games[0]);
        await playGame(my_solved_games.solvedGamesList[0]);
        await tapNewGameButton();

        await verifyInitialGameTiles(my_games.games[1]);
        await playGame(my_solved_games.solvedGamesList[1]);
        await tapNewGameButton();

        await verifyInitialGameTiles(my_games.games[2]);
        await playGame(my_solved_games.solvedGamesList[2]);
        await tapNewGameButton();

        await verifyInitialGameTiles(my_games.games[3]);
        await playGame(my_solved_games.solvedGamesList[3]);
        await tapNewGameButton();

        await verifyInitialGameTiles(my_games.games[4]);
        await playGame(my_solved_games.solvedGamesList[4]);
        await tapNewGameButton();

        await verifyInitialGameTiles(my_games.games[5]);
        await playGame(my_solved_games.solvedGamesList[5]);
        await tapNewGameButton();

        await verifyInitialGameTiles(my_games.games[6]);
        await playGame(my_solved_games.solvedGamesList[6]);
        await tapNewGameButton();

        await verifyInitialGameTiles(my_games.games[7]);
        await playGame(my_solved_games.solvedGamesList[7]);
        await tapNewGameButton();

        await verifyInitialGameTiles(my_games.games[8]);
        await playGame(my_solved_games.solvedGamesList[8]);
        await tapNewGameButton();

        await verifyInitialGameTiles(my_games.games[9]);
        await playGame(my_solved_games.solvedGamesList[9]);
        await tapNewGameButton();
      }, timeout: Timeout(Duration(seconds: 300)));
    });
  });
}
