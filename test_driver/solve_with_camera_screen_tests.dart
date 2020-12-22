import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_games.dart' as my_games;
import 'package:test/test.dart';
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
      await driver.requestData(my_strings.setPictureMock);
      await navigateToSolveWithCameraScreen();
    });

    tearDown(() async {
      await driver.requestData(my_strings.deletePictureMock);
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

    test('pressing "TAKE PHOTO" eventually presents a constructed Sudoku', () async {
      await driver.runUnsynchronized(() async {
        await waitForThenTap(find.text('TAKE PHOTO'));
        await driver.waitFor(find.text('YES, SOLVE IT'));
        await verifyInitialGameTiles(my_games.games[0]);
      });
    }, timeout: Timeout(Duration(seconds: 60)));

    //   test('pressing "STOP CONSTRUCTING" brings you back to the "take photo" screen', () async {});
    //   test('pressing "NO, RETAKE PHOTO" brings you back to the "take photo" screen', () async {});
    //   test('pressing "YES, SOLVE IT" shows the "solving" screen', () async {});
    //   test('pressing "YES, SOLVE IT" solves the sudoku', () async {});
    //   test('pressing "RESTART" shows the "take photo" screen', () async {});

    //   group('different photos', () {
    //     test('good photo', () async {});
    //     test('bad photo', () async {});
    //   });

    //   group('Completing interrupted journies', () {
    //     test('stop constructing', () async {});
    //     test('stop solving', () async {});
    //     test('retake photo', () async {});
    //     test('back button during construction', () async {});
    //     test('back button during solve', () async {});
    //   });
  });
}
