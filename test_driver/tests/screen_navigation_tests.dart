import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '../utils/shared.dart';

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

    test('navigating to SolveWithCameraScreen then back will preserve this state', () async {},
        timeout: defaultTimeout);
    test('navigating to SolveWithTouchScreen then back will preserve this state', () async {}, timeout: defaultTimeout);

    test('SolveWithTouchScreen should show a different state', () async {}, timeout: defaultTimeout);

    test('we start on the HomeScreen', () async {
      await waitToAppear(find.text('How would you like it to be solved?'));
    }, timeout: defaultTimeout);

    test('pressing "SOLVE WITH CAMERA" button brings us to the SolveWithCameraScreen', () async {
      await pressSolveWithCameraButton();

      await waitToAppear(find.text('Camera'));
    }, timeout: defaultTimeout);

    test('pressing "SOLVE WITH TOUCH" button brings us to the SolveWithTouchScreen', () async {
      await pressSolveWithTouchButton();

      await waitToAppear(find.text('Touch'));
    }, timeout: defaultTimeout);

    test('pressing "JUST PLAY" button brings us to the JustPlayScreen', () async {
      await pressJustPlayButton();

      await waitToAppear(find.text('Play'));
    }, timeout: defaultTimeout);

    test('pressing "Help" on SolveWithCameraScreen takes you to SolveWithCameraHelpScreen', () async {
      await pressSolveWithCameraButton();

      await pressHelpOnDropDownMenu('SolveWithCameraScreenDropDownMenuWidget');
      await waitToAppear(find.text('1. Align your sudoku with the camera'));
    }, timeout: defaultTimeout);

    test('pressing "Help" on SolveWithTouchScreen takes you to SolveWithTouchHelpScreen', () async {
      await pressSolveWithTouchButton();

      await pressHelpOnDropDownMenu('SolveWithTouchScreenDropDownMenuWidget');
      await waitToAppear(find.text('1. Touch a tile to select it'));
    }, timeout: defaultTimeout);

    test('pressing "Help" on JustPlayScreen takes you to JustPlayHelpScreen', () async {
      await pressJustPlayButton();

      await pressHelpOnDropDownMenu('JustPlayScreenDropDownMenuWidget');
      await waitToAppear(find.text('1. Touch a tile to select it'));
    }, timeout: defaultTimeout);
  });
}
