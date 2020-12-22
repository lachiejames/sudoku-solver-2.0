import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_games.dart' as my_games;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:test/test.dart';

import 'my_solved_games.dart' as my_solved_games;
import 'shared.dart';

void main() {
  group('SolveWithCameraScreen tests ->', () {
    setUpAll(() async {
      await initTests();
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    setUp(() async {
      await hotRestart();
      await driver.requestData(my_strings.setVeryHighResPictureMock);
      await navigateToSolveWithCameraScreen();
    });

    tearDown(() async {
      await driver.requestData(my_strings.deletePictureMock);
    });

    group('standard journeys', () {
      test('presented with the Taking Photo screen', () async {
        await driver.runUnsynchronized(() async {
          await driver.waitFor(find.text('Camera'));
          await driver.waitFor(find.text('Align with camera'));
          await driver.waitFor(find.byType('CameraWidget'));
          await driver.waitFor(find.text('TAKE PHOTO'));
        });
      });

      test('pressing "TAKE PHOTO" shows the "constructing sudoku" screen', () async {
        await driver.runUnsynchronized(() async {
          await driver.waitFor(find.byType('CameraWidget'));
          await waitForThenTap(find.text('TAKE PHOTO'));
          await driver.waitFor(find.text('Constructing Sudoku...'));
          await driver.waitFor(find.text('STOP CONSTRUCTING'));
          await driver.waitFor(find.byType('CircularProgressIndicator'));
          await driver.waitFor(find.byType('SudokuWidget'));
        });
      });

      test('pressing "STOP CONSTRUCTING" brings you back to the "take photo" screen', () async {
        await driver.runUnsynchronized(() async {
          await waitForThenTap(find.text('TAKE PHOTO'));
          await waitForThenTap(find.text('STOP CONSTRUCTING'));

          await driver.waitFor(find.text('Camera'));
          await driver.waitFor(find.text('Align with camera'));
          await driver.waitFor(find.byType('CameraWidget'));
          await driver.waitFor(find.text('TAKE PHOTO'));
        });
      });

      test('pressing "TAKE PHOTO" eventually presents the Verify Photo screen', () async {
        await driver.runUnsynchronized(() async {
          await waitForThenTap(find.text('TAKE PHOTO'));

          await driver.waitFor(find.text('Is this your Sudoku?'));
          await driver.waitFor(find.byType('SudokuWidget'));
          await driver.waitFor(find.text('YES, SOLVE IT'));
          await driver.waitFor(find.text('NO, RETAKE PHOTO'));

          await verifyInitialGameTiles(my_games.games[0]);
        });
      }, timeout: Timeout(Duration(seconds: 60)));

      test('pressing "NO, RETAKE PHOTO" brings you back to the "take photo" screen', () async {
        await driver.runUnsynchronized(() async {
          await waitForThenTap(find.text('TAKE PHOTO'));
          await waitForThenTap(find.text('NO, RETAKE PHOTO'));

          await driver.waitFor(find.text('Camera'));
          await driver.waitFor(find.text('Align with camera'));
          await driver.waitFor(find.byType('CameraWidget'));
          await driver.waitFor(find.text('TAKE PHOTO'));
        });
      }, timeout: Timeout(Duration(seconds: 60)));

      test('pressing "YES, SOLVE IT" shows the "solving" screen', () async {
        await driver.runUnsynchronized(() async {
          await waitForThenTap(find.text('TAKE PHOTO'));
          await waitForThenTap(find.text('YES, SOLVE IT'));

          await driver.waitFor(find.text('AI thinking...'));
          await driver.waitFor(find.byType('CircularProgressIndicator'));
          await driver.waitFor(find.byType('SudokuWidget'));
          await driver.waitFor(find.text('STOP SOLVING'));
        });
      }, timeout: Timeout(Duration(seconds: 60)));

      test('pressing "YES, SOLVE IT" solves the sudoku', () async {
        await waitForThenTap(find.text('TAKE PHOTO'));

        await driver.waitFor(find.text('YES, SOLVE IT'));
        await verifyInitialGameTiles(my_games.games[0]);
        await driver.tap(find.text('YES, SOLVE IT'));

        await driver.waitFor(find.text('RESTART'));
        await verifyInitialGameTiles(my_solved_games.solvedGamesList[0]);
      }, timeout: Timeout(Duration(seconds: 120)));

      test('pressing "RESTART" shows the "take photo" screen', () async {
        await waitForThenTap(find.text('TAKE PHOTO'));
        await waitForThenTap(find.text('YES, SOLVE IT'));
        await waitForThenTap(find.text('RESTART'));

        await driver.waitFor(find.text('Camera'));
        await driver.waitFor(find.text('Align with camera'));
        await driver.waitFor(find.byType('CameraWidget'));
        await driver.waitFor(find.text('TAKE PHOTO'));
      }, timeout: Timeout(Duration(seconds: 120)));
    });

    group('different photo resolutions', () {
      test('very high res - 2160x3840', () async {
        await driver.requestData(my_strings.setVeryHighResPictureMock);

        await waitForThenTap(find.text('TAKE PHOTO'));

        await driver.waitFor(find.text('YES, SOLVE IT'));
        await verifyInitialGameTiles(my_games.games[0]);
        await driver.tap(find.text('YES, SOLVE IT'));

        await driver.waitFor(find.text('RESTART'));
        await verifyInitialGameTiles(my_solved_games.solvedGamesList[0]);
      }, timeout: Timeout(Duration(seconds: 120)));


      // Not solving constructing sudoku correctly :(
      // test('high res - 1080x1920', () async {
      //   await driver.requestData(my_strings.setHighResPictureMock);

      //   await waitForThenTap(find.text('TAKE PHOTO'));

      //   await driver.waitFor(find.text('YES, SOLVE IT'));
      //   await verifyInitialGameTiles(my_games.games[0]);
      //   await driver.tap(find.text('YES, SOLVE IT'));

      //   await driver.waitFor(find.text('RESTART'));
      //   await verifyInitialGameTiles(my_solved_games.solvedGamesList[0]);
      // }, timeout: Timeout(Duration(seconds: 120)));

      // Not solving constructing sudoku correctly :(
      // test('medium res - 720x1280', () async {
      //   await driver.requestData(my_strings.setMediumResPictureMock);

      //   await waitForThenTap(find.text('TAKE PHOTO'));

      //   await driver.waitFor(find.text('YES, SOLVE IT'));
      //   await verifyInitialGameTiles(my_games.games[0]);
      //   await driver.tap(find.text('YES, SOLVE IT'));

      //   await driver.waitFor(find.text('RESTART'));
      //   await verifyInitialGameTiles(my_solved_games.solvedGamesList[0]);
      // }, timeout: Timeout(Duration(seconds: 120)));
    });

    //   group('Completing interrupted journies', () {
    //     test('stop constructing', () async {});
    //     test('stop solving', () async {});
    //     test('retake photo', () async {});
    //     test('back button during construction', () async {});
    //     test('back button during solve', () async {});
    //   });
  });
}
