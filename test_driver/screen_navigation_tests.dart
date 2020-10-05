import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:test/test.dart';

import 'shared.dart';

void main() {
  group('Screen navigation tests ->', () {
    setUpAll(() async {
      await initTests();
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    setUp(() async {
      await hotRestart();
    });

    test('navigating to SolveWithCameraScreen then back will preserve this state', () async {});
    test('navigating to SolveWithTouchScreen then back will preserve this state', () async {});
    test('SolveWithTouchScreen should show a different state', () async {});

    test('we start on the HomeScreen', () async {
      await driver.waitFor(find.text(my_strings.topTextHome));
    });

    test('pressing "SOLVE WITH CAMERA" button brings us to the SolveWithCameraScreen', () async {
      await pressSolveWithCameraButton();

      await driver.waitFor(find.text(my_strings.solveWithCameraScreenName));
    });

    test('pressing "SOLVE WITH TOUCH" button brings us to the SolveWithTouchScreen', () async {
      await pressSolveWithTouchButton();

      await driver.waitFor(find.text(my_strings.solveWithTouchScreenName));
    });

    test('pressing "JUST PLAY" button brings us to the JustPlayScreen', () async {
      await pressJustPlayButton();

      await driver.waitFor(find.text(my_strings.justPlayScreenName));
    });

    test('pressing "Help" on SolveWithCameraScreen takes you to SolveWithCameraHelpScreen',
        () async {
      await pressSolveWithCameraButton();

      await pressHelpOnDropDownMenu('SolveWithCameraScreenDropDownMenuWidget');
      await driver.waitFor(find.text('1. Align your sudoku with the camera'));
    });

    test('pressing "Help" on SolveWithTouchScreen takes you to SolveWithTouchHelpScreen', () async {
      await pressSolveWithTouchButton();

      await pressHelpOnDropDownMenu('SolveWithTouchScreenDropDownMenuWidget');
      await driver.waitFor(find.text('1. Touch a tile to select it'));
    });

    test('pressing "Help" on JustPlayScreen takes you to JustPlayHelpScreen', () async {
      await pressJustPlayButton();

      await pressHelpOnDropDownMenu('JustPlayScreenDropDownMenuWidget');
      await driver.waitFor(find.text('1. Touch a tile to select it'));
    });
  });
}
