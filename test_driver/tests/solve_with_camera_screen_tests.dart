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
          await waitToAppear(find.text('Camera'));
          await waitToAppear(find.text('Align with camera'));
          await waitToAppear(find.byType('CameraWidget'));
          await waitToAppear(find.text('TAKE PHOTO'));
        });
      }, timeout: defaultTimeout);

      test('pressing "TAKE PHOTO" shows the "constructing sudoku" screen', () async {
        await driver.runUnsynchronized(() async {
          print('xxx 1');
          await waitToAppear(find.byType('CameraWidget'));
          print('xxx 2');
          await waitForThenTap(find.text('TAKE PHOTO'));
          print('xxx 3');
          await waitToAppear(find.text('Constructing Sudoku...'));
          print('xxx 4');
          await waitToAppear(find.text('STOP CONSTRUCTING'));
          print('xxx 5');
          await waitToAppear(find.byType('CircularProgressIndicator'));
          print('xxx 6');
          await waitToAppear(find.byType('SudokuWidget'));
          print('xxx 7');
        });
      }, timeout: defaultTimeout);

      test('pressing "STOP CONSTRUCTING" brings you back to the "take photo" screen', () async {
        await driver.runUnsynchronized(() async {
          await waitForThenTap(find.text('TAKE PHOTO'));
          await waitForThenTap(find.text('STOP CONSTRUCTING'));

          await waitToAppear(find.text('Camera'));
          await waitToAppear(find.text('Align with camera'));
          await waitToAppear(find.byType('CameraWidget'));
          await waitToAppear(find.text('TAKE PHOTO'));
        });
      }, timeout: defaultTimeout);

      test('pressing "TAKE PHOTO" eventually presents the Verify Photo screen', () async {
        await driver.runUnsynchronized(() async {
          await waitForThenTap(find.text('TAKE PHOTO'));

          await waitToAppear(find.text('Is this your Sudoku?'));
          await waitToAppear(find.byType('SudokuWidget'));
          await waitToAppear(find.text('SOLVE SUDOKU'));
          await waitToAppear(find.text('RETAKE PHOTO'));

          await verifyInitialGameTiles(games[0]);
        });
      }, timeout: longTimeout);

      test('pressing "RETAKE PHOTO" brings you back to the "take photo" screen', () async {
        await driver.runUnsynchronized(() async {
          await waitForThenTap(find.text('TAKE PHOTO'));
          await waitForThenTap(find.text('RETAKE PHOTO'));

          await waitToAppear(find.text('Camera'));
          await waitToAppear(find.text('Align with camera'));
          await waitToAppear(find.byType('CameraWidget'));
          await waitToAppear(find.text('TAKE PHOTO'));
        });
      }, timeout: longTimeout);

      test('pressing "SOLVE SUDOKU" shows the "solving" screen', () async {
        await driver.runUnsynchronized(() async {
          await waitForThenTap(find.text('TAKE PHOTO'));
          await waitForThenTap(find.text('SOLVE SUDOKU'));

          await waitToAppear(find.text('AI thinking...'));
          await waitToAppear(find.byType('CircularProgressIndicator'));
          await waitToAppear(find.byType('SudokuWidget'));
          await waitToAppear(find.text('STOP SOLVING'));
        });
      }, timeout: longTimeout);

      test('pressing "SOLVE SUDOKU" solves the sudoku', () async {
        await waitForThenTap(find.text('TAKE PHOTO'));

        await waitToAppear(find.text('SOLVE SUDOKU'));
        await verifyInitialGameTiles(games[0]);
        await driver.tap(find.text('SOLVE SUDOKU'));

        await waitToAppear(find.text('RESTART'));
        await verifyInitialGameTiles(my_solved_games.solvedGamesList[0]);
      }, timeout: longTimeout);

      test('pressing "RESTART" shows the "take photo" screen', () async {
        await waitForThenTap(find.text('TAKE PHOTO'));
        await waitForThenTap(find.text('SOLVE SUDOKU'));
        await waitForThenTap(find.text('RESTART'));

        await waitToAppear(find.text('Camera'));
        await waitToAppear(find.text('Align with camera'));
        await waitToAppear(find.byType('CameraWidget'));
        await waitToAppear(find.text('TAKE PHOTO'));
      }, timeout: longTimeout);
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

        await waitToAppear(find.text('SOLVE SUDOKU'));
        await verifyInitialGameTiles(games[0]);
        await driver.tap(find.text('SOLVE SUDOKU'));

        await waitToAppear(find.text('RESTART'));
        await verifyInitialGameTiles(my_solved_games.solvedGamesList[0]);
      }, timeout: longTimeout);

      // Not solving constructing sudoku correctly :(
      // test('high res - 1080x1920', () async {
      //   await driver.requestData(setHighResPictureMock);

      //   await waitForThenTap(find.text('TAKE PHOTO'));

      //   await waitToAppear(find.text('SOLVE SUDOKU'));
      //   await verifyInitialGameTiles(games[0]);
      //   await driver.tap(find.text('SOLVE SUDOKU'));

      //   await waitToAppear(find.text('RESTART'));
      //   await verifyInitialGameTiles(my_solved_games.solvedGamesList[0]);
      // }, timeout: Timeout(Duration(seconds: 120)));

      // Not solving constructing sudoku correctly :(
      // test('medium res - 720x1280', () async {
      //   await driver.requestData(setMediumResPictureMock);

      //   await waitForThenTap(find.text('TAKE PHOTO'));

      //   await waitToAppear(find.text('SOLVE SUDOKU'));
      //   await verifyInitialGameTiles(games[0]);
      //   await driver.tap(find.text('SOLVE SUDOKU'));

      //   await waitToAppear(find.text('RESTART'));
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
          await waitToAppear(find.text('Camera not found'));
          await waitToAppear(find.text('RETURN TO HOME'));
        }, timeout: defaultTimeout);

        test('pressing "RETURN TO HOME" brings you back to home screen', () async {
          await waitForThenTap(find.text('RETURN TO HOME'));

          await waitToAppear(find.text('How would you like it to be solved?'));
          await waitToAppear(find.text('SOLVE WITH CAMERA'));
          await waitToAppear(find.text('SOLVE WITH TOUCH'));
          await waitToAppear(find.text('JUST PLAY'));
        }, timeout: defaultTimeout);
      });
      group('photo processing error', () {
        setUp(() async {
          await driver.requestData('setPhotoProcessingErrorMock');
          await hotRestart();
          await navigateToSolveWithCameraScreen();
          await waitForThenTap(find.text('TAKE PHOTO'));
        });

        test('shows "Photo Processing Error" screen', () async {
          await waitToAppear(find.text('Unable to generate Sudoku'));
          await waitToAppear(find.text('RETAKE PHOTO'));
          await waitToAppear(find.text('RETURN TO HOME'));
        }, timeout: defaultTimeout);

        test('pressing "RETAKE PHOTO" brings you back to taking photo screen', () async {
          await waitForThenTap(find.text('RETAKE PHOTO'));

          await waitToAppear(find.text('Camera'));
          await waitToAppear(find.text('Align with camera'));
          await waitToAppear(find.byType('CameraWidget'));
          await waitToAppear(find.text('TAKE PHOTO'));
        }, timeout: defaultTimeout);

        test('pressing "RETURN TO HOME" brings you back to home screen', () async {
          await waitForThenTap(find.text('RETURN TO HOME'));

          await waitToAppear(find.text('How would you like it to be solved?'));
          await waitToAppear(find.text('SOLVE WITH CAMERA'));
          await waitToAppear(find.text('SOLVE WITH TOUCH'));
          await waitToAppear(find.text('JUST PLAY'));
        }, timeout: defaultTimeout);
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

            await waitToAppear(find.text('The A.I. timed out'));
            await waitToAppear(find.text('SOLVE SUDOKU'));
            await waitToAppear(find.text('RETAKE PHOTO'));
          });
        }, timeout: longTimeout);
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

            await waitToAppear(find.text('Cannot solve, Sudoku is invalid'));
            await waitToAppear(find.text('SOLVE SUDOKU'));
            await waitToAppear(find.text('RETAKE PHOTO'));
          });
        }, timeout: defaultTimeout);
      });
    });
  });
}
