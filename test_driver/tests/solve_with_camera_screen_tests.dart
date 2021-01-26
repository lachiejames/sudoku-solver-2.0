import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../utils/games.dart';
import '../utils/shared.dart';
import '../utils/solved_games.dart' as my_solved_games;

void main() {
  group('SolveWithCameraScreen tests ->', () {
    setUpAll(() async {
      await initTests();
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    tearDown(() async {
      await driver.requestData('deleteAllMocks');
    });

    group('standard journeys', () {
      setUp(() async {
        await hotRestart();
        await driver.requestData('setVeryHighResPictureMock');
        await navigateToSolveWithCameraScreen();
      });

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
          await driver.waitFor(find.text('SOLVE SUDOKU'));
          await driver.waitFor(find.text('RETAKE PHOTO'));

          await verifyInitialGameTiles(games[0]);
        });
      }, timeout: Timeout(Duration(seconds: 60)));

      test('pressing "RETAKE PHOTO" brings you back to the "take photo" screen', () async {
        await driver.runUnsynchronized(() async {
          await waitForThenTap(find.text('TAKE PHOTO'));
          await waitForThenTap(find.text('RETAKE PHOTO'));

          await driver.waitFor(find.text('Camera'));
          await driver.waitFor(find.text('Align with camera'));
          await driver.waitFor(find.byType('CameraWidget'));
          await driver.waitFor(find.text('TAKE PHOTO'));
        });
      }, timeout: Timeout(Duration(seconds: 60)));

      test('pressing "SOLVE SUDOKU" shows the "solving" screen', () async {
        await driver.runUnsynchronized(() async {
          await waitForThenTap(find.text('TAKE PHOTO'));
          await waitForThenTap(find.text('SOLVE SUDOKU'));

          await driver.waitFor(find.text('AI thinking...'));
          await driver.waitFor(find.byType('CircularProgressIndicator'));
          await driver.waitFor(find.byType('SudokuWidget'));
          await driver.waitFor(find.text('STOP SOLVING'));
        });
      }, timeout: Timeout(Duration(seconds: 60)));

      test('pressing "SOLVE SUDOKU" solves the sudoku', () async {
        await waitForThenTap(find.text('TAKE PHOTO'));

        await driver.waitFor(find.text('SOLVE SUDOKU'));
        await verifyInitialGameTiles(games[0]);
        await driver.tap(find.text('SOLVE SUDOKU'));

        await driver.waitFor(find.text('RESTART'));
        await verifyInitialGameTiles(my_solved_games.solvedGamesList[0]);
      }, timeout: Timeout(Duration(seconds: 120)));

      test('pressing "RESTART" shows the "take photo" screen', () async {
        await waitForThenTap(find.text('TAKE PHOTO'));
        await waitForThenTap(find.text('SOLVE SUDOKU'));
        await waitForThenTap(find.text('RESTART'));

        await driver.waitFor(find.text('Camera'));
        await driver.waitFor(find.text('Align with camera'));
        await driver.waitFor(find.byType('CameraWidget'));
        await driver.waitFor(find.text('TAKE PHOTO'));
      }, timeout: Timeout(Duration(seconds: 120)));
    });

    group('different photo resolutions', () {
      setUp(() async {
        await hotRestart();
        await driver.requestData('setVeryHighResPictureMock');
        await navigateToSolveWithCameraScreen();
      });

      test('very high res - 2160x3840', () async {
        await driver.requestData('setVeryHighResPictureMock');

        await waitForThenTap(find.text('TAKE PHOTO'));

        await driver.waitFor(find.text('SOLVE SUDOKU'));
        await verifyInitialGameTiles(games[0]);
        await driver.tap(find.text('SOLVE SUDOKU'));

        await driver.waitFor(find.text('RESTART'));
        await verifyInitialGameTiles(my_solved_games.solvedGamesList[0]);
      }, timeout: Timeout(Duration(seconds: 120)));

      // Not solving constructing sudoku correctly :(
      // test('high res - 1080x1920', () async {
      //   await driver.requestData(setHighResPictureMock);

      //   await waitForThenTap(find.text('TAKE PHOTO'));

      //   await driver.waitFor(find.text('SOLVE SUDOKU'));
      //   await verifyInitialGameTiles(games[0]);
      //   await driver.tap(find.text('SOLVE SUDOKU'));

      //   await driver.waitFor(find.text('RESTART'));
      //   await verifyInitialGameTiles(my_solved_games.solvedGamesList[0]);
      // }, timeout: Timeout(Duration(seconds: 120)));

      // Not solving constructing sudoku correctly :(
      // test('medium res - 720x1280', () async {
      //   await driver.requestData(setMediumResPictureMock);

      //   await waitForThenTap(find.text('TAKE PHOTO'));

      //   await driver.waitFor(find.text('SOLVE SUDOKU'));
      //   await verifyInitialGameTiles(games[0]);
      //   await driver.tap(find.text('SOLVE SUDOKU'));

      //   await driver.waitFor(find.text('RESTART'));
      //   await verifyInitialGameTiles(my_solved_games.solvedGamesList[0]);
      // }, timeout: Timeout(Duration(seconds: 120)));
    });

    group('Error scenarios', () {
      group('camera not loaded error', () {
        setUp(() async {
          await driver.requestData('setCameraNotFoundErrorMock');
          await hotRestart();
          await navigateToSolveWithCameraScreen();
        });

        test('shows "Camera Not Loaded Error" screen', () async {
          await driver.waitFor(find.text('Camera not found'));
          await driver.waitFor(find.text('RETURN TO HOME'));
        });

        test('pressing "RETURN TO HOME" brings you back to home screen', () async {
          await waitForThenTap(find.text('RETURN TO HOME'));

          await driver.waitFor(find.text('How would you like it to be solved?'));
          await driver.waitFor(find.text('SOLVE WITH CAMERA'));
          await driver.waitFor(find.text('SOLVE WITH TOUCH'));
          await driver.waitFor(find.text('JUST PLAY'));
        });
      });
      group('photo processing error', () {
        setUp(() async {
          await driver.requestData('setPhotoProcessingErrorMock');
          await hotRestart();
          await navigateToSolveWithCameraScreen();
          await waitForThenTap(find.text('TAKE PHOTO'));
        });

        test('shows "Photo Processing Error" screen', () async {
          await driver.waitFor(find.text('Unable to generate Sudoku'));
          await driver.waitFor(find.text('RETAKE PHOTO'));
          await driver.waitFor(find.text('RETURN TO HOME'));
        });

        test('pressing "RETAKE PHOTO" brings you back to taking photo screen', () async {
          await waitForThenTap(find.text('RETAKE PHOTO'));

          await driver.waitFor(find.text('Camera'));
          await driver.waitFor(find.text('Align with camera'));
          await driver.waitFor(find.byType('CameraWidget'));
          await driver.waitFor(find.text('TAKE PHOTO'));
        });

        test('pressing "RETURN TO HOME" brings you back to home screen', () async {
          await waitForThenTap(find.text('RETURN TO HOME'));

          await driver.waitFor(find.text('How would you like it to be solved?'));
          await driver.waitFor(find.text('SOLVE WITH CAMERA'));
          await driver.waitFor(find.text('SOLVE WITH TOUCH'));
          await driver.waitFor(find.text('JUST PLAY'));
        });
      });

      group('solving timeout', () {
        setUp(() async {
          await hotRestart();
          await driver.requestData('setTimeoutErrorPictureMock');

          await navigateToSolveWithCameraScreen();
        });

        test('shows expected widgets', () async {
          await driver.runUnsynchronized(() async {
            await waitForThenTap(find.text('TAKE PHOTO'));
            await waitForThenTap(find.text('SOLVE SUDOKU'));

            await driver.waitFor(find.text('The A.I. timed out'));
            await driver.waitFor(find.text('SOLVE SUDOKU'));
            await driver.waitFor(find.text('RETAKE PHOTO'));
          });
        }, timeout: Timeout(Duration(seconds: 60)));
      });

      group('solving invalid', () {
        setUp(() async {
          await hotRestart();
          await driver.requestData('setInvalidErrorPictureMock');
          await navigateToSolveWithCameraScreen();
        });

        test('shows expected widgets', () async {
          await driver.runUnsynchronized(() async {
            await waitForThenTap(find.text('TAKE PHOTO'));
            await waitForThenTap(find.text('SOLVE SUDOKU'));

            await driver.waitFor(find.text('Cannot solve, Sudoku is invalid'));
            await driver.waitFor(find.text('SOLVE SUDOKU'));
            await driver.waitFor(find.text('RETAKE PHOTO'));
          });
        });
      });
    });
  });
}
