import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:test/test.dart';

import '../utils/games.dart';
import '../utils/shared.dart';
import '../utils/solved_games.dart' as my_solved_games;

void main() {
  group('JustPlayScreen tests ->', () {
    setUpAll(() async {
      await initTests();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    setUp(() async {
      await hotRestart();
      await navigateToJustPlayScreen();
    });

    group('regular tiles ->', () {
      test('tapping a tile changes its color from white to green', () async {
        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await tapTile(const TileKey(row: 2, col: 2));
        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'green', textColor: 'black', hasX: false);
      }, timeout: defaultTimeout);

      test('tapping a selected tile changes color from green to white', () async {
        await tapTile(const TileKey(row: 2, col: 2));
        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'green', textColor: 'black', hasX: false);
        await tapTile(const TileKey(row: 2, col: 2));
        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
      }, timeout: defaultTimeout);

      test('tapping a tile with a value adds an X', () async {
        await addNumberToTile(7, const TileKey(row: 2, col: 2));
        await tapTile(const TileKey(row: 2, col: 2));
        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'green', textColor: 'black', hasX: true);
        await tapTile(const TileKey(row: 2, col: 2));
        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
      }, timeout: defaultTimeout);

      test('tapping a tile changes all numbers from white to green', () async {
        await expectNumbersAre(color: 'white');

        await tapTile(const TileKey(row: 2, col: 2));

        await expectNumbersAre(color: 'green');
      }, timeout: defaultTimeout);

      test('tapping a selected tile changes all numbers from green to white', () async {
        await tapTile(const TileKey(row: 2, col: 2));

        await expectNumbersAre(color: 'green');

        await tapTile(const TileKey(row: 2, col: 2));

        await expectNumbersAre(color: 'white');
      }, timeout: defaultTimeout);

      test('pressing a tile, then a number, should add that number to the tile', () async {
        await expectNumberOnTileToBe(null, const TileKey(row: 2, col: 2));

        await addNumberToTile(7, const TileKey(row: 2, col: 2));
        await expectNumberOnTileToBe(7, const TileKey(row: 2, col: 2));
      }, timeout: defaultTimeout);

      test('tapping a tile while another tile is selected will update tile colors', () async {
        await tapTile(const TileKey(row: 2, col: 2));
        await tapTile(const TileKey(row: 2, col: 3));

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 2, col: 3), color: 'green', textColor: 'black', hasX: false);
      }, timeout: defaultTimeout);

      test('double tapping a tile removes its value', () async {
        await addNumberToTile(7, const TileKey(row: 2, col: 2));
        await expectNumberOnTileToBe(7, const TileKey(row: 2, col: 2));

        await doubleTapTile(const TileKey(row: 2, col: 2));
        await expectNumberOnTileToBe(null, const TileKey(row: 2, col: 2));
      }, timeout: defaultTimeout);

      test('adding an invalid tile changes textColor from black to red', () async {
        await addNumberToTile(5, const TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'red', hasX: false);
      }, timeout: defaultTimeout);

      test('removing an invalid tile changes textColor from red to black', () async {
        await addNumberToTile(5, const TileKey(row: 2, col: 2));
        await doubleTapTile(const TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
      }, timeout: defaultTimeout);

      test('adding many invalid tiles changes textColor from black to red', () async {
        await addNumberToTile(5, const TileKey(row: 2, col: 2));
        await addNumberToTile(5, const TileKey(row: 1, col: 3));
        await addNumberToTile(9, const TileKey(row: 2, col: 3));

        await expectTileIs(tileKey: const TileKey(row: 1, col: 1), color: 'grey', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 1, col: 3), color: 'white', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 2, col: 3), color: 'white', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 2, col: 5), color: 'grey', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 2, col: 6), color: 'grey', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 3, col: 2), color: 'grey', textColor: 'red', hasX: false);
      }, timeout: defaultTimeout);

      test('removing all invalid tiles changes textColor from red to black', () async {
        await addNumberToTile(5, const TileKey(row: 1, col: 3));
        await addNumberToTile(5, const TileKey(row: 2, col: 2));
        await addNumberToTile(9, const TileKey(row: 2, col: 3));
        await doubleTapTile(const TileKey(row: 1, col: 3));
        await doubleTapTile(const TileKey(row: 2, col: 2));
        await doubleTapTile(const TileKey(row: 2, col: 3));

        await expectTileIs(tileKey: const TileKey(row: 1, col: 1), color: 'grey', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 1, col: 3), color: 'white', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 2, col: 3), color: 'white', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 2, col: 5), color: 'grey', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 2, col: 6), color: 'grey', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 3, col: 2), color: 'grey', textColor: 'black', hasX: false);
      }, timeout: defaultTimeout);
    });

    group('original tiles ->', () {
      test('tapping a tile changes no colors, and does not remove the value', () async {
        await expectNumberOnTileToBe(5, const TileKey(row: 1, col: 1));
        await expectTileIs(tileKey: const TileKey(row: 3, col: 2), color: 'grey', textColor: 'black', hasX: false);

        await tapTile(const TileKey(row: 1, col: 1));

        await expectTileIs(tileKey: const TileKey(row: 3, col: 2), color: 'grey', textColor: 'black', hasX: false);

        await tapNumber(7);

        await expectNumberOnTileToBe(5, const TileKey(row: 1, col: 1));
        await expectTileIs(tileKey: const TileKey(row: 3, col: 2), color: 'grey', textColor: 'black', hasX: false);
      }, timeout: defaultTimeout);
    });

    group('restart ->', () {
      test('pressing RESTART deselects all tiles and numbers', () async {
        await tapTile(const TileKey(row: 2, col: 2));
        await pressRestartOnDropDownMenu('JustPlayScreenDropDownMenuWidget');

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await expectNumbersAre(color: 'white');
      }, timeout: defaultTimeout);

      test('pressing RESTART resets invalid tiles', () async {
        await addNumberToTile(5, const TileKey(row: 2, col: 2));
        await tapTile(const TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'green', textColor: 'red', hasX: true);
        await expectNumbersAre(color: 'green');

        await pressRestartOnDropDownMenu('JustPlayScreenDropDownMenuWidget');

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await expectNumbersAre(color: 'white');
      }, timeout: defaultTimeout);

      test('pressing RESTART makes new game button disappear', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await waitToAppear(find.text('NEW GAME'));

        await pressRestartOnDropDownMenu('JustPlayScreenDropDownMenuWidget');
        await waitToDisappear(find.text('NEW GAME'));
      }, timeout: defaultTimeout);
    });

    group('help ->', () {
      test('pressing HELP then navigating back will preserve board state', () async {
        await addNumberToTile(5, const TileKey(row: 2, col: 2));
        await tapTile(const TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'green', textColor: 'red', hasX: true);
        await expectNumbersAre(color: 'green');

        await pressHelpOnDropDownMenu('JustPlayScreenDropDownMenuWidget');
        await pressBackButton();

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'green', textColor: 'red', hasX: true);
        await expectNumbersAre(color: 'green');
      }, timeout: defaultTimeout);
    });

    group('new game ->', () {
      test('NEW GAME button will not appear when invalid tiles are present', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await waitToAppear(find.text('NEW GAME'));
        await addNumberToTile(5, const TileKey(row: 2, col: 2));
        await waitToDisappear(find.text('NEW GAME'));
      }, timeout: defaultTimeout);

      test('NEW GAME button appears', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await waitToAppear(find.text('NEW GAME'));
      }, timeout: defaultTimeout);

      test('if a value is removed, NEW GAME button disappears', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await waitToAppear(find.text('NEW GAME'));
        await doubleTapTile(const TileKey(row: 2, col: 2));
        await waitToDisappear(find.text('NEW GAME'));
      }, timeout: defaultTimeout);

      test('pressing NEW GAME dehighlights all tiles and numbers', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await tapTile(const TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'green', textColor: 'black', hasX: true);

        await waitForThenTap(find.text('NEW GAME'));

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
      }, timeout: defaultTimeout);
    });

    group('playing a game ->', () {
      test('initial values on the board should be the values in game0', () async {
        await verifyInitialGameTiles(games[0]);
      }, timeout: defaultTimeout);

      test('adding correct values to all blank tiles will finish the game', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await waitToAppear(find.text('SOLVED'));
        await waitToAppear(find.text('NEW GAME'));
      }, timeout: defaultTimeout);

      test('can play 2 games in a row', () async {
        await verifyInitialGameTiles(games[0]);
        await playGame(my_solved_games.solvedGamesList[0]);
        await tapNewGameButton();

        await waitToDisappear(find.text('NEW GAME'));
        await waitToAppear(find.text('Pick a tile'));

        await verifyInitialGameTiles(games[1]);
        await playGame(my_solved_games.solvedGamesList[1]);
        await tapNewGameButton();

        await waitToAppear(find.text('Pick a tile'));
        await waitToDisappear(find.text('NEW GAME'));

        await verifyInitialGameTiles(games[2]);
      }, timeout: longTimeout);
    });
  });
}
