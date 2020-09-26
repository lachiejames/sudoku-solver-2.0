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
    driver = await FlutterDriver.connect(dartVmServiceUrl: 'http://127.0.0.1:8888/');

    await driver.requestData(my_strings.hotRestart);
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
  });

  group('JustPlayScreen tests ->', () {
    void navigateToJustPlayScreen() async {
      await driver.tap(find.text(my_strings.justPlayButtonText));
      await driver.getText(find.text(my_strings.topTextNoTileSelected));
    }

    void tapTile(TileKey tileKey) async {
      await driver.tap(find.byValueKey('${tileKey.toString()}'));
    }

    void doubleTapTile(TileKey tileKey) async {
      await tapTile(tileKey);
      await tapTile(tileKey);
    }

    void tapNumber(int number) async {
      await driver.tap(find.byValueKey('Number($number)'));
    }

    void addNumberToTile(int number, TileKey tileKey) async {
      await tapTile(tileKey);
      await tapNumber(number);
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
      test('initial values on the board should be the values in game0', () async {
        List<List<int>> game0 = my_games.games[0];
        for (int row = 1; row <= 9; row++) {
          for (int col = 1; col <= 9; col++) {
            await expectNumberOnTileToBe(game0[row - 1][col - 1], TileKey(row: row, col: col));
          }
        }
      });

      test('adding correct values to all blank tiles will finish the game', () async {
        List<List<int>> game0 = my_solved_games.solvedGamesList[0];
        for (int row = 1; row <= 9; row++) {
          for (int col = 1; col <= 9; col++) {
            if (await getNumberOnTile(TileKey(row: row, col: col)) == null) {
              await addNumberToTile(game0[row - 1][col - 1], TileKey(row: row, col: col));
            }
          }
        }
      });
    });
  });
}
