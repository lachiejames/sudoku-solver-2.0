import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:test/test.dart';

import 'shared.dart';

void main() async {
  FlutterDriver driver;

  setUpAll(() async {
    await grantAppPermissions();
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
  });

  group('Screen navigation tests -', () {
    // Restart app at beginning of each test
    setUp(() async {
      await driver.requestData(MyStrings.hotRestart);
    });
    test('we start on the HomeScreen', () async {
      await driver.getText(find.text(MyStrings.topTextHome));
    });

    test('pressing "SOLVE WITH CAMERA" button on HomeScreen brings us to the SolveWithCameraScreen',
        () async {
      await driver.tap(find.text(MyStrings.solveWithCameraButtonText));
      await driver.getText(find.text(MyStrings.topTextTakingPhoto));
    });

    test('pressing "SOLVE WITH TOUCH" button on HomeScreen brings us to the SolveWithTouchScreen',
        () async {
      await driver.tap(find.text(MyStrings.solveWithTouchButtonText));
      await driver.getText(find.text(MyStrings.topTextNoTileSelected));
    });

    test('pressing "JUST PLAY" button on HomeScreen brings us to the JustPlayScreen', () async {
      await driver.tap(find.text(MyStrings.justPlayButtonText));
      await driver.getText(find.text(MyStrings.topTextNoTileSelected));
    });

    test('pressing "Help" on SolveWithCameraScreen takes you to SolveWithCameraHelpScreen',
        () async {
      await driver.tap(find.text(MyStrings.solveWithCameraButtonText));
      await driver.tap(find.byType('SolveWithCameraScreenDropDownMenuWidget'));
      await driver.tap(find.text(MyStrings.dropDownMenuOption2));
      await driver.getText(find.text(MyStrings.tip1SolveWithCameraScreen));
    });

    test('pressing "Help" on SolveWithTouchScreen takes you to SolveWithTouchHelpScreen', () async {
      await driver.tap(find.text(MyStrings.solveWithTouchButtonText));
      await driver.tap(find.byType('SolveWithTouchScreenDropDownMenuWidget'));
      await driver.tap(find.text(MyStrings.dropDownMenuOption2));
      await driver.getText(find.text(MyStrings.tip1SolveWithTouchScreen));
    });

    test('pressing "Help" on JustPlayScreen takes you to JustPlayHelpScreen', () async {
      await driver.tap(find.text(MyStrings.justPlayButtonText));
      await driver.tap(find.byType('JustPlayScreenDropDownMenuWidget'));
      await driver.tap(find.text(MyStrings.dropDownMenuOption2));
      await driver.getText(find.text(MyStrings.tip1JustPlayScreen));
    });
  });
}
