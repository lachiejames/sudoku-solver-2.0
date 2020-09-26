import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:test/test.dart';

import 'shared.dart';

void main() async {
  FlutterDriver driver;

  setUpAll(() async {
    await grantAppPermissions();
    driver = await FlutterDriver.connect(dartVmServiceUrl: 'http://127.0.0.1:8888/');
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
  });

  group('Screen navigation tests -', () {
    // Restart app at beginning of each test
    setUp(() async {
      await driver.requestData(my_strings.hotRestart);
    });
    test('we start on the HomeScreen', () async {
      await driver.getText(find.text(my_strings.topTextHome));
    });

    test('pressing "SOLVE WITH CAMERA" button on HomeScreen brings us to the SolveWithCameraScreen',
        () async {
      await driver.tap(find.text(my_strings.solveWithCameraButtonText));
      await driver.getText(find.text(my_strings.topTextTakingPhoto));
    });

    test('pressing "SOLVE WITH TOUCH" button on HomeScreen brings us to the SolveWithTouchScreen',
        () async {
      await driver.tap(find.text(my_strings.solveWithTouchButtonText));
      await driver.getText(find.text(my_strings.topTextNoTileSelected));
    });

    test('pressing "JUST PLAY" button on HomeScreen brings us to the JustPlayScreen', () async {
      await driver.tap(find.text(my_strings.justPlayButtonText));
      await driver.getText(find.text(my_strings.topTextNoTileSelected));
    });

    test('pressing "Help" on SolveWithCameraScreen takes you to SolveWithCameraHelpScreen',
        () async {
      await driver.tap(find.text(my_strings.solveWithCameraButtonText));
      await driver.tap(find.byType('SolveWithCameraScreenDropDownMenuWidget'));
      await driver.tap(find.text(my_strings.dropDownMenuOption2));
      await driver.getText(find.text('1. Align your sudoku with the camera'));
    });

    test('pressing "Help" on SolveWithTouchScreen takes you to SolveWithTouchHelpScreen', () async {
      await driver.tap(find.text(my_strings.solveWithTouchButtonText));
      await driver.tap(find.byType('SolveWithTouchScreenDropDownMenuWidget'));
      await driver.tap(find.text(my_strings.dropDownMenuOption2));
      await driver.getText(find.text('1. Touch a tile to select it'));
    });

    test('pressing "Help" on JustPlayScreen takes you to JustPlayHelpScreen', () async {
      await driver.tap(find.text(my_strings.justPlayButtonText));
      await driver.tap(find.byType('JustPlayScreenDropDownMenuWidget'));
      await driver.tap(find.text(my_strings.dropDownMenuOption2));
      await driver.getText(find.text('1. Touch a tile to select it'));
    });
  });
}
