import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_games.dart' as my_games;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:test/test.dart';

import 'my_solved_games.dart' as my_solved_games;
import 'shared.dart';

void main() {
  FlutterDriver driver;

  group('JustPlayScreen tests ->', () {
    setUpAll(() async {
      await grantAppPermissions();
      driver = await FlutterDriver.connect(dartVmServiceUrl: my_strings.dartVMServiceUrl);
      setDriver(driver);
      await hotRestart();
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    setUp(() async {
      await hotRestart();
      await navigateToJustPlayScreen();
    });
    group('for regular tiles ->', () {
      // Restart app at beginning of each test
      test('pressing a tile should make it green', () async {
        await expectTilePropertiesToBe(
          tileKey: TileKey(row: 2, col: 2),
          color: 'white',
          textColor: 'black',
        );

        await tapTile(TileKey(row: 2, col: 2));

        await expectTilePropertiesToBe(
          tileKey: TileKey(row: 2, col: 2),
          color: 'green',
          textColor: 'black',
        );
      });

      test('pressing a tile should make all numbers green', () async {
        for (int number = 1; number <= 9; number++) {
          await expectNumberPropertiesToBe(
            number: number,
            color: 'white',
          );
        }

        await tapTile(TileKey(row: 2, col: 2));

        for (int number = 1; number <= 9; number++) {
          await expectNumberPropertiesToBe(
            number: number,
            color: 'green',
          );
        }
      });

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
