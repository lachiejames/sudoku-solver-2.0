import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_games.dart' as my_games;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:test/test.dart';

import 'my_solved_games.dart' as my_solved_games;
import 'shared.dart';

void main() {
  FlutterDriver driver;

  void navigateToJustPlayScreen() async {
    await waitForThenTap(driver, find.text(my_strings.justPlayButtonText));
    await driver.getText(find.text(my_strings.topTextNoTileSelected));
  }

  void tapTile(TileKey tileKey) async {
    await waitForThenTap(driver, find.byValueKey('${tileKey.toString()}'));
  }

  void doubleTapTile(TileKey tileKey) async {
    await tapTile(tileKey);
    await tapTile(tileKey);
  }

  void tapNumber(int number) async {
    await waitForThenTap(driver, find.byValueKey('Number($number)'));
  }

  void addNumberToTile(int number, TileKey tileKey) async {
    await tapTile(tileKey);
    await tapNumber(number);
  }

  void tapNewGameButton() async {
    await waitForThenTap(driver, find.text('NEW GAME'));
  }

  Future<int> getNumberOnTile(TileKey tileKey) async {
    await driver.waitUntilNoTransientCallbacks();
    String tileText = await driver.getText(find.byValueKey('${tileKey.toString()}_text'));

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
        int numberOnTile = await getNumberOnTile(TileKey(row: row, col: col));
        if (numberOnTile == null) {
          await addNumberToTile(game[row - 1][col - 1], TileKey(row: row, col: col));
        }
      }
    }
  }

  group('JustPlayScreen tests ->', () {
    setUpAll(() async {
      await grantAppPermissions();
      driver = await FlutterDriver.connect(dartVmServiceUrl: my_strings.dartVMServiceUrl);
      await hotRestart(driver);
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    setUp(() async {
      await hotRestart(driver);
      await navigateToJustPlayScreen();
    });
    group('for regular tiles ->', () {
      // Restart app at beginning of each test

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
      test('initial values on the board should be the values in game0', () async {
        await verifyInitialGameTiles(my_games.games[0]);
      });

      test('adding correct values to all blank tiles will finish the game', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await driver.getText(find.text('SOLVED'));
        await driver.getText(find.text('NEW GAME'));
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
