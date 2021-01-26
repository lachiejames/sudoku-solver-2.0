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
      if (driver != null) await driver.close();
    });

    setUp(() async {
      await hotRestart();
      await navigateToSolveWithTouchScreen();
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
        await addNumberToTile(5, TileKey(row: 1, col: 1));
        await addNumberToTile(5, TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: TileKey(row: 1, col: 1), color: 'white', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'red', hasX: false);
      });

      test('removing an invalid tile changes textColor from red to black', () async {
        await addNumberToTile(5, TileKey(row: 1, col: 1));
        await addNumberToTile(5, TileKey(row: 2, col: 2));

        await doubleTapTile(TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: TileKey(row: 1, col: 1), color: 'white', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
      });

      test('adding many invalid tiles changes textColor from black to red', () async {
        await addNumberToTile(5, TileKey(row: 1, col: 1));
        await addNumberToTile(5, TileKey(row: 2, col: 2));
        await addNumberToTile(5, TileKey(row: 1, col: 9));

        await expectTileIs(tileKey: TileKey(row: 1, col: 1), color: 'white', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'red', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 1, col: 9), color: 'white', textColor: 'red', hasX: false);
      });

      test('removing all invalid tiles changes textColor from red to black', () async {
        await addNumberToTile(5, TileKey(row: 1, col: 1));
        await addNumberToTile(5, TileKey(row: 2, col: 2));
        await addNumberToTile(5, TileKey(row: 1, col: 9));

        await doubleTapTile(TileKey(row: 1, col: 1));
        await doubleTapTile(TileKey(row: 2, col: 2));
        await doubleTapTile(TileKey(row: 1, col: 9));

        await expectTileIs(tileKey: TileKey(row: 1, col: 1), color: 'white', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await expectTileIs(tileKey: TileKey(row: 1, col: 9), color: 'white', textColor: 'black', hasX: false);
      });
    });

    group('restart ->', () {
      test('pressing RESTART deselects all tiles and numbers', () async {
        await tapTile(TileKey(row: 2, col: 2));
        await pressRestartOnDropDownMenu('SolveWithTouchScreenDropDownMenuWidget');

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await expectNumbersAre(color: 'white');
      });

      test('pressing RESTART resets invalid tiles', () async {
        await addNumberToTile(5, TileKey(row: 1, col: 1));
        await addNumberToTile(5, TileKey(row: 2, col: 2));
        await tapTile(TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'green', textColor: 'red', hasX: true);
        await expectNumbersAre(color: 'green');

        await pressRestartOnDropDownMenu('SolveWithTouchScreenDropDownMenuWidget');

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'white', textColor: 'black', hasX: false);
        await expectNumbersAre(color: 'white');
      });

      test('pressing RESTART stops solving the sudoku', () async {
        await driver.runUnsynchronized(() async {
          await addSudoku(solvingTimeoutErrorGame);
          await waitForThenTap(find.text('SOLVE SUDOKU'));

          await driver.waitFor(find.text('STOP SOLVING'));
          await pressRestartOnDropDownMenu('SolveWithTouchScreenDropDownMenuWidget');
          await driver.waitFor(find.text('SOLVE SUDOKU'));
        });
      });
    });

    group('help ->', () {
      test('pressing HELP then navigating back will preserve board state', () async {
        await addNumberToTile(5, TileKey(row: 1, col: 1));
        await addNumberToTile(5, TileKey(row: 2, col: 2));
        await tapTile(TileKey(row: 2, col: 2));

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'green', textColor: 'red', hasX: true);
        await expectNumbersAre(color: 'green');

        await pressHelpOnDropDownMenu('SolveWithTouchScreenDropDownMenuWidget');
        await pressBackButton();

        await expectTileIs(tileKey: TileKey(row: 2, col: 2), color: 'green', textColor: 'red', hasX: true);
        await expectNumbersAre(color: 'green');
      });
    });

    group('solving a sudoku ->', () {
      test('adding correct values to all blank tiles will finish the game', () async {
        await playGame(my_solved_games.solvedGamesList[0]);
        await driver.waitFor(find.text('SOLVED'));
        await driver.waitFor(find.text('RESTART'));
      });

      test('a STOP SOLVING button will appear during the solve', () async {
        await addSudoku(games[0]);

        await driver.runUnsynchronized(() async {
          await waitForThenTap(find.text('SOLVE SUDOKU'));
          await waitForThenTap(find.text('STOP SOLVING'));
        });
      });

      test('pressing STOP SOLVING will stop the solve', () async {
        await addSudoku(games[0]);

        await driver.runUnsynchronized(() async {
          await waitForThenTap(find.text('SOLVE SUDOKU'));
          await waitForThenTap(find.text('STOP SOLVING'));
        });

        await driver.waitFor(find.text('Pick a tile'));
        await driver.waitFor(find.text('SOLVE SUDOKU'));
      });

      test('can solve 2 games in a row', () async {
        await addSudoku(games[0]);
        await waitForThenTap(find.text('SOLVE SUDOKU'));
        await waitForThenTap(find.text('RESTART'));

        await addSudoku(games[2]);
        await waitForThenTap(find.text('SOLVE SUDOKU'));
        await waitForThenTap(find.text('RESTART'));
      }, timeout: Timeout(Duration(seconds: 60)));

      test('solving timeout', () async {
        await driver.runUnsynchronized(() async {
          await addSudoku(solvingTimeoutErrorGame);
          await waitForThenTap(find.text('SOLVE SUDOKU'));
          await driver.waitFor(find.text('The A.I. timed out'));
        });
      }, timeout: Timeout(Duration(seconds: 40)));

      test('solving invalid', () async {
        await driver.runUnsynchronized(() async {
          await addSudoku(solvingInvalidErrorGame);
          await waitForThenTap(find.text('SOLVE SUDOKU'));
          await driver.waitFor(find.text('Cannot solve, Sudoku is invalid'));
        });
      });
    });
  });
}
