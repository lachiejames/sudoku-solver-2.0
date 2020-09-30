import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_games.dart' as my_games;
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:test/test.dart';

import 'my_solved_games.dart' as my_solved_games;
import 'shared.dart';

void main() {
  group('JustPlayScreen tests ->', () {
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

    group('regular tiles ->', () {
      test('tapping a tile changes its color from white to green', () async {
        await expectTilePropertiesToBe(
          tileKey: TileKey(row: 2, col: 2),
          color: 'white',
          textColor: 'black',
          hasX: false,
        );

        await tapTile(TileKey(row: 2, col: 2));

        await expectTilePropertiesToBe(
          tileKey: TileKey(row: 2, col: 2),
          color: 'green',
          textColor: 'black',
          hasX: false,
        );
      });

      test('tapping a selected tile changes color from green to white', () async {
        await tapTile(TileKey(row: 2, col: 2));

        await expectTilePropertiesToBe(
          tileKey: TileKey(row: 2, col: 2),
          color: 'green',
          textColor: 'black',
          hasX: false,
        );

        await tapTile(TileKey(row: 2, col: 2));

        await expectTilePropertiesToBe(
          tileKey: TileKey(row: 2, col: 2),
          color: 'white',
          textColor: 'black',
          hasX: false,
        );
      });

      test('tapping a tile with a value adds an X', () async {
        await addNumberToTile(7, TileKey(row: 2, col: 2));
        await tapTile(TileKey(row: 2, col: 2));

        await expectTilePropertiesToBe(
          tileKey: TileKey(row: 2, col: 2),
          color: 'green',
          textColor: 'black',
          hasX: true,
        );

        await tapTile(TileKey(row: 2, col: 2));

        await expectTilePropertiesToBe(
          tileKey: TileKey(row: 2, col: 2),
          color: 'white',
          textColor: 'black',
          hasX: false,
        );
      });

      test('tapping a tile changes all numbers from white to green', () async {
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
      
      test('tapping a selected tile changes all numbers from green to white', () async {
        await tapTile(TileKey(row: 2, col: 2));

        for (int number = 1; number <= 9; number++) {
          await expectNumberPropertiesToBe(
            number: number,
            color: 'green',
          );
        }

        await tapTile(TileKey(row: 2, col: 2));

        for (int number = 1; number <= 9; number++) {
          await expectNumberPropertiesToBe(
            number: number,
            color: 'white',
          );
        }
      });

      test('pressing a tile, then a number, should add that number to the tile', () async {
        await expectNumberOnTileToBe(null, TileKey(row: 2, col: 2));

        await addNumberToTile(7, TileKey(row: 2, col: 2));
        await expectNumberOnTileToBe(7, TileKey(row: 2, col: 2));
      });

      test('double tapping a tile removes its value', () async {
        await addNumberToTile(7, TileKey(row: 2, col: 2));
        await expectNumberOnTileToBe(7, TileKey(row: 2, col: 2));

        await doubleTapTile(TileKey(row: 2, col: 2));
        await expectNumberOnTileToBe(null, TileKey(row: 2, col: 2));
      });

      test('adding an invalid tile changes textColor from black to red', () async {});
      test('removing an invalid tile changes textColor from red to black', () async {});

      test('adding many invalid tiles changes textColor from black to red', () async {});
      test('removing all invalid tiles changes textColor from red to black', () async {});

      test('tapping a tile while another tile is selected will update tile colors', () async {});
    });

    group('original tiles ->', () {
      test('tapping a tile changes no colors, and does not remove the value', () async {
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

    group('restart ->', () {
      test('pressing RESTART deselects all tiles and numbers', () async {});
      test('pressing RESTART makes new game button disappear', () async {});
    });

    group('help ->', () {
      test('pressing HELP then navigating back will preserve board state', () async {});
    });

    group('new game ->', () {
      test('NEW GAME button will not appear when invalid tiles are present', () async {});
      test('NEW GAME button appears', () async {});
      test('if a value is removed, NEW GAME button disappears', () async {});
      test('if invalid tile is added, NEW GAME button disappears', () async {});
      test('pressing NEW GAME loads new tiles with expected properties', () async {});
      test('pressing NEW GAME dehighlights all tiles and numbers', () async {});
    });

    // group('playing a game ->', () {
    //   test('initial values on the board should be the values in game0', () async {
    //     await verifyInitialGameTiles(my_games.games[0]);
    //   });

    //   test('adding correct values to all blank tiles will finish the game', () async {
    //     await playGame(my_solved_games.solvedGamesList[0]);
    //     await driver.getText(find.text('SOLVED'));
    //     await driver.getText(find.text('NEW GAME'));
    //   });

    //   test('pressing NEW GAME will load a new sudoku', () async {
    //     await driver.getText(find.text('Pick a tile'));

    //     await verifyInitialGameTiles(my_games.games[0]);
    //     await playGame(my_solved_games.solvedGamesList[0]);
    //     await tapNewGameButton();

    //     await driver.getText(find.text('Pick a tile'));
    //     await verifyInitialGameTiles(my_games.games[1]);
    //   });

    //   test('can play 2 games in a row', () async {
    //     await playGame(my_solved_games.solvedGamesList[0]);
    //     await tapNewGameButton();

    //     await playGame(my_solved_games.solvedGamesList[1]);
    //     await tapNewGameButton();
    //   }, timeout: Timeout(Duration(seconds: 60)));
    // });
  });
}
