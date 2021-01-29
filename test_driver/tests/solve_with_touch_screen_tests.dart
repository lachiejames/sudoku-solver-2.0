import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:test/test.dart';

import '../utils/games.dart';
import '../utils/shared.dart';
import '../utils/solved_games.dart' as my_solved_games;

void main() {
  group('SolveWithTouchScreen tests ->', () {
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
      await navigateToSolveWithTouchScreen();
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
        await addNumberToTile(5, const TileKey(row: 1, col: 1));
        await addNumberToTile(5, const TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: const TileKey(row: 1, col: 1), color: 'white', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'red', hasX: false);
      }, timeout: defaultTimeout);

      test('removing an invalid tile changes textColor from red to black', () async {
        await addNumberToTile(5, const TileKey(row: 1, col: 1));
        await addNumberToTile(5, const TileKey(row: 2, col: 2));

        await doubleTapTile(const TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: const TileKey(row: 1, col: 1), color: 'white', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
      }, timeout: defaultTimeout);

      test('adding many invalid tiles changes textColor from black to red', () async {
        await addNumberToTile(5, const TileKey(row: 1, col: 1));
        await addNumberToTile(5, const TileKey(row: 2, col: 2));
        await addNumberToTile(5, const TileKey(row: 1, col: 9));

        await expectTileIs(tileKey: const TileKey(row: 1, col: 1), color: 'white', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 1, col: 9), color: 'white', textColor: 'red', hasX: false);
      }, timeout: defaultTimeout);

      test('removing all invalid tiles changes textColor from red to black', () async {
        await addNumberToTile(5, const TileKey(row: 1, col: 1));
        await addNumberToTile(5, const TileKey(row: 2, col: 2));
        await addNumberToTile(5, const TileKey(row: 1, col: 9));

        await doubleTapTile(const TileKey(row: 1, col: 1));
        await doubleTapTile(const TileKey(row: 2, col: 2));
        await doubleTapTile(const TileKey(row: 1, col: 9));

        await expectTileIs(tileKey: const TileKey(row: 1, col: 1), color: 'white', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: const TileKey(row: 1, col: 9), color: 'white', textColor: 'black', hasX: false);
      }, timeout: defaultTimeout);
    });

    group('restart ->', () {
      test('pressing RESTART deselects all tiles and numbers', () async {
        await tapTile(const TileKey(row: 2, col: 2));
        await pressRestartOnDropDownMenu('SolveWithTouchScreenDropDownMenuWidget');

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await expectNumbersAre(color: 'white');
      }, timeout: defaultTimeout);

      test('pressing RESTART resets invalid tiles', () async {
        await addNumberToTile(5, const TileKey(row: 1, col: 1));
        await addNumberToTile(5, const TileKey(row: 2, col: 2));
        await tapTile(const TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'green', textColor: 'red', hasX: true);
        await expectNumbersAre(color: 'green');

        await pressRestartOnDropDownMenu('SolveWithTouchScreenDropDownMenuWidget');

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await expectNumbersAre(color: 'white');
      }, timeout: defaultTimeout);

      test('pressing RESTART stops solving the sudoku', () async {
        await driver.runUnsynchronized(() async {
          await addSudoku(solvingTimeoutErrorGame);
          await waitForThenTap(find.text('SOLVE SUDOKU'));

          await waitToAppear(find.text('STOP SOLVING'));
          await pressRestartOnDropDownMenu('SolveWithTouchScreenDropDownMenuWidget');
          await waitToAppear(find.text('SOLVE SUDOKU'));
        });
      }, timeout: defaultTimeout);
    });

    group('help ->', () {
      test('pressing HELP then navigating back will preserve board state', () async {
        await addNumberToTile(5, const TileKey(row: 1, col: 1));
        await addNumberToTile(5, const TileKey(row: 2, col: 2));
        await tapTile(const TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'green', textColor: 'red', hasX: true);
        await expectNumbersAre(color: 'green');

        await pressHelpOnDropDownMenu('SolveWithTouchScreenDropDownMenuWidget');
        await pressBackButton();

        await expectTileIs(tileKey: const TileKey(row: 2, col: 2), color: 'green', textColor: 'red', hasX: true);
        await expectNumbersAre(color: 'green');
      }, timeout: defaultTimeout);
    });

    group('solving a sudoku ->', () {
      test('adding correct values to all blank tiles will finish the game', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await waitToAppear(find.text('SOLVED'));
        await waitToAppear(find.text('RESTART'));
      }, timeout: defaultTimeout);

      test('a STOP SOLVING button will appear during the solve', () async {
        await addSudoku(games[0]);

        await driver.runUnsynchronized(() async {
          await waitForThenTap(find.text('SOLVE SUDOKU'));
          await waitForThenTap(find.text('STOP SOLVING'));
        });
      }, timeout: defaultTimeout);

      test('pressing STOP SOLVING will stop the solve', () async {
        await addSudoku(games[0]);

        await driver.runUnsynchronized(() async {
          await waitForThenTap(find.text('SOLVE SUDOKU'));
          await waitForThenTap(find.text('STOP SOLVING'));
        });

        await waitToAppear(find.text('Pick a tile'));
        await waitToAppear(find.text('SOLVE SUDOKU'));
      }, timeout: defaultTimeout);

      test('can solve 2 games in a row', () async {
        await addSudoku(games[0]);
        await waitForThenTap(find.text('SOLVE SUDOKU'));
        await waitForThenTap(find.text('RESTART'));

        await addSudoku(games[2]);
        await waitForThenTap(find.text('SOLVE SUDOKU'));
        await waitForThenTap(find.text('RESTART'));
      }, timeout: longTimeout);

      test('solving timeout', () async {
        await driver.runUnsynchronized(() async {
          await addSudoku(solvingTimeoutErrorGame);
          await waitForThenTap(find.text('SOLVE SUDOKU'));
          await waitToAppear(find.text('The A.I. timed out'));
        });
      }, timeout: longTimeout);

      test('solving invalid', () async {
        await driver.runUnsynchronized(() async {
          await addSudoku(solvingInvalidErrorGame);
          await waitForThenTap(find.text('SOLVE SUDOKU'));
          await waitToAppear(find.text('Cannot solve, Sudoku is invalid'));
        });
      }, timeout: defaultTimeout);
    });
  });
}
