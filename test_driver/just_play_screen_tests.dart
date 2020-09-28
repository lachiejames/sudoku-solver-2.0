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

  group('JustPlayScreen tests ->', () {
    void navigateToJustPlayScreen() async {
      await driver.tap(find.text(my_strings.justPlayButtonText));
      await driver.waitUntilNoTransientCallbacks();
      await driver.getText(find.text(my_strings.topTextNoTileSelected));
    }

    void tapTile(TileKey tileKey) async {
      await driver.tap(find.byValueKey('${tileKey.toString()}'));
      await driver.waitUntilNoTransientCallbacks();
    }

    void doubleTapTile(TileKey tileKey) async {
      await tapTile(tileKey);
      await tapTile(tileKey);
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

    group('for regular tiles ->', () {
      test('pressing a tile, then a number, should add that number to the tile', () async {
        await expectNumberOnTileToBe(null, TileKey(row: 2, col: 2));

        await addNumberToTile(7, TileKey(row: 2, col: 2));
        await expectNumberOnTileToBe(7, TileKey(row: 2, col: 2));
      });

      test('double tapping the tile should remove its value', () async {
        await addNumberToTile(7, TileKey(row: 2, col: 2));
        await expectNumberOnTileToBe(7, TileKey(row: 2, col: 2));

        await doubleTapTile(TileKey(row: 2, col: 2));
        await expectNumberOnTileToBe(null, TileKey(row: 2, col: 2));
      });
    });

    group('for original tiles ->', () {
      test('pressing a tile, then a number, should NOT add that number to the tile', () async {
        await expectNumberOnTileToBe(5, TileKey(row: 1, col: 1));
        await addNumberToTile(7, TileKey(row: 1, col: 1));
        await expectNumberOnTileToBe(5, TileKey(row: 1, col: 1));
      });

      test('double tapping the tile should NOT remove its value', () async {
        await expectNumberOnTileToBe(5, TileKey(row: 1, col: 1));
        await doubleTapTile(TileKey(row: 1, col: 1));
        await expectNumberOnTileToBe(5, TileKey(row: 1, col: 1));
      });
    });

    group('playing a game ->', () {
      Future<void> verifyInitialGameTiles(List<List<int>> game) async {
        for (int row = 1; row <= 9; row++) {
          for (int col = 1; col <= 9; col++) {
            print('($row, $col) -> ${game[row - 1][col - 1]}');
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

      test('initial values on the board should be the values in game0', () async {
        await verifyInitialGameTiles(my_games.games[0]);
      });

      test('adding correct values to all blank tiles will finish the game', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await driver.getText(find.text('SOLVED'));
        await tapNewGameButton();
      });

      test('pressing NEW GAME will load a new sudoku', () async {
        await driver.getText(find.text('Pick a tile'));

        await verifyInitialGameTiles(my_games.games[0]);
        await playGame(my_solved_games.solvedGamesList[0]);
        await tapNewGameButton();

        await driver.getText(find.text('Pick a tile'));
        await verifyInitialGameTiles(my_games.games[1]);
      });

      test('can play 2 games in a row', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await tapNewGameButton();

        await playGame(my_solved_games.solvedGamesList[1]);
        await tapNewGameButton();
      }, timeout: Timeout(Duration(seconds: 60)));
    });
  });
}
