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
        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await tapTile(TileKey(row: 2, col: 2));
        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'green', textColor: 'black', hasX: false);
      });

      test('tapping a selected tile changes color from green to white', () async {
        await tapTile(TileKey(row: 2, col: 2));
        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'green', textColor: 'black', hasX: false);
        await tapTile(TileKey(row: 2, col: 2));
        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
      });

      test('tapping a tile with a value adds an X', () async {
        await addNumberToTile(7, TileKey(row: 2, col: 2));
        await tapTile(TileKey(row: 2, col: 2));
        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'green', textColor: 'black', hasX: true);
        await tapTile(TileKey(row: 2, col: 2));
        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
      });

      test('tapping a tile changes all numbers from white to green', () async {
        await expectNumbersAre(color: 'white');

        await tapTile(TileKey(row: 2, col: 2));

        await expectNumbersAre(color: 'green');
      });

      test('tapping a selected tile changes all numbers from green to white', () async {
        await tapTile(TileKey(row: 2, col: 2));

        await expectNumbersAre(color: 'green');

        await tapTile(TileKey(row: 2, col: 2));

        await expectNumbersAre(color: 'white');
      });

      test('pressing a tile, then a number, should add that number to the tile', () async {
        await expectNumberOnTileToBe(null, TileKey(row: 2, col: 2));

        await addNumberToTile(7, TileKey(row: 2, col: 2));
        await expectNumberOnTileToBe(7, TileKey(row: 2, col: 2));
      });

      test('tapping a tile while another tile is selected will update tile colors', () async {
        await tapTile(TileKey(row: 2, col: 2));
        await tapTile(TileKey(row: 2, col: 3));

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 2, col: 3), color: 'green', textColor: 'black', hasX: false);
      });

      test('double tapping a tile removes its value', () async {
        await addNumberToTile(7, TileKey(row: 2, col: 2));
        await expectNumberOnTileToBe(7, TileKey(row: 2, col: 2));

        await doubleTapTile(TileKey(row: 2, col: 2));
        await expectNumberOnTileToBe(null, TileKey(row: 2, col: 2));
      });

      test('adding an invalid tile changes textColor from black to red', () async {
        await addNumberToTile(5, TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'red', hasX: false);
      });

      test('removing an invalid tile changes textColor from red to black', () async {
        await addNumberToTile(5, TileKey(row: 2, col: 2));
        await doubleTapTile(TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
      });

      test('adding many invalid tiles changes textColor from black to red', () async {
        await addNumberToTile(5, TileKey(row: 2, col: 2));
        await addNumberToTile(5, TileKey(row: 1, col: 3));
        await addNumberToTile(9, TileKey(row: 2, col: 3));

        await expectTileIs(tileKey: TileKey(row: 1, col: 1), color: 'grey', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 1, col: 3), color: 'white', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 2, col: 3), color: 'white', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 2, col: 5), color: 'grey', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 2, col: 6), color: 'grey', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 3, col: 2), color: 'grey', textColor: 'red', hasX: false);
      });

      test('removing all invalid tiles changes textColor from red to black', () async {
        await addNumberToTile(5, TileKey(row: 1, col: 3));
        await addNumberToTile(5, TileKey(row: 2, col: 2));
        await addNumberToTile(9, TileKey(row: 2, col: 3));
        await doubleTapTile(TileKey(row: 1, col: 3));
        await doubleTapTile(TileKey(row: 2, col: 2));
        await doubleTapTile(TileKey(row: 2, col: 3));

        await expectTileIs(tileKey: TileKey(row: 1, col: 1), color: 'grey', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 1, col: 3), color: 'white', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 2, col: 3), color: 'white', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 2, col: 5), color: 'grey', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 2, col: 6), color: 'grey', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 3, col: 2), color: 'grey', textColor: 'black', hasX: false);
      });
    });

    group('original tiles ->', () {
      test('tapping a tile changes no colors, and does not remove the value', () async {
        await expectNumberOnTileToBe(5, TileKey(row: 1, col: 1));
        await expectTileIs(tileKey: TileKey(row: 3, col: 2), color: 'grey', textColor: 'black', hasX: false);

        await tapTile(TileKey(row: 1, col: 1));

        await expectTileIs(tileKey: TileKey(row: 3, col: 2), color: 'grey', textColor: 'black', hasX: false);

        await tapNumber(7);

        await expectNumberOnTileToBe(5, TileKey(row: 1, col: 1));
        await expectTileIs(tileKey: TileKey(row: 3, col: 2), color: 'grey', textColor: 'black', hasX: false);
      });
    });

    group('restart ->', () {
      test('pressing RESTART deselects all tiles and numbers', () async {
        await tapTile(TileKey(row: 2, col: 2));
        await pressRestartOnDropDownMenu('JustPlayScreenDropDownMenuWidget');

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await expectNumbersAre(color: 'white');
      });

      test('pressing RESTART resets invalid tiles', () async {
        await addNumberToTile(5, TileKey(row: 2, col: 2));
        await tapTile(TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'green', textColor: 'red', hasX: true);
        await expectNumbersAre(color: 'green');

        await pressRestartOnDropDownMenu('JustPlayScreenDropDownMenuWidget');

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await expectNumbersAre(color: 'white');
      });

      test('pressing RESTART makes new game button disappear', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await driver.waitFor(find.text('NEW GAME'));

        await pressRestartOnDropDownMenu('JustPlayScreenDropDownMenuWidget');
        await driver.waitForAbsent(find.text('NEW GAME'));
      });
    });

    group('help ->', () {
      test('pressing HELP then navigating back will preserve board state', () async {
        await addNumberToTile(5, TileKey(row: 2, col: 2));
        await tapTile(TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'green', textColor: 'red', hasX: true);
        await expectNumbersAre(color: 'green');

        await pressHelpOnDropDownMenu('JustPlayScreenDropDownMenuWidget');
        await pressBackButton();

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'green', textColor: 'red', hasX: true);
        await expectNumbersAre(color: 'green');
      });
    });

    group('new game ->', () {
      test('NEW GAME button will not appear when invalid tiles are present', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await driver.waitFor(find.text('NEW GAME'));
        await addNumberToTile(5, TileKey(row: 2, col: 2));
        await driver.waitForAbsent(find.text('NEW GAME'));
      });
      test('NEW GAME button appears', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await driver.waitFor(find.text('NEW GAME'));
      });
      test('if a value is removed, NEW GAME button disappears', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await driver.waitFor(find.text('NEW GAME'));
        await doubleTapTile(TileKey(row: 2, col: 2));
        await driver.waitForAbsent(find.text('NEW GAME'));
      });
      test('pressing NEW GAME dehighlights all tiles and numbers', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await tapTile(TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'green', textColor: 'black', hasX: true);

        await waitForThenTap(find.text('NEW GAME'));

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
      });
    });

    group('playing a game ->', () {
      test('initial values on the board should be the values in game0', () async {
        await verifyInitialGameTiles(my_games.games[0]);
      });

      test('adding correct values to all blank tiles will finish the game', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await driver.waitFor(find.text('SOLVED'));
        await driver.waitFor(find.text('NEW GAME'));
      });

      test('can play 2 games in a row', () async {
        await verifyInitialGameTiles(my_games.games[0]);
        await playGame(my_solved_games.solvedGamesList[0]);
        await tapNewGameButton();

        await driver.waitForAbsent(find.text('NEW GAME'));
        await driver.waitFor(find.text('Pick a tile'));

        await verifyInitialGameTiles(my_games.games[1]);
        await playGame(my_solved_games.solvedGamesList[1]);
        await tapNewGameButton();

        await driver.waitFor(find.text('Pick a tile'));
        await driver.waitForAbsent(find.text('NEW GAME'));

        await verifyInitialGameTiles(my_games.games[2]);
      }, timeout: Timeout(Duration(seconds: 60)));
    });
  });
}
