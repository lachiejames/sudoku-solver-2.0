import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:test/test.dart';

import 'shared.dart';

void main() async {
  FlutterDriver driver;

  setUpAll(() async {
    await grantAppPermissions();
    driver = await FlutterDriver.connect(dartVmServiceUrl: my_strings.dartVMServiceUrl);
    await driver.waitUntilNoTransientCallbacks();
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
  });

  group('Screen navigation tests -', () {
    void pressSolveWithCameraButton() async {
      await driver.tap(find.text(my_strings.solveWithCameraButtonText));
      await driver.waitUntilNoTransientCallbacks();
    }

    void pressSolveWithTouchButton() async {
      await driver.tap(find.text(my_strings.solveWithTouchButtonText));
      await driver.waitUntilNoTransientCallbacks();
    }

    void pressJustPlayButton() async {
      await driver.tap(find.text(my_strings.justPlayButtonText));
      await driver.waitUntilNoTransientCallbacks();
    }

    void pressHelpOnDropDownMenu(String dropDownMenuType) async {
      await driver.tap(find.byType(dropDownMenuType));
      await driver.waitUntilNoTransientCallbacks();

      await driver.tap(find.text(my_strings.dropDownMenuOption2));
      await driver.waitUntilNoTransientCallbacks();
    }

    // Restart app at beginning of each test
    setUp(() async {
      await driver.requestData(my_strings.hotRestart);
      await driver.waitUntilNoTransientCallbacks();
    });
    test('we start on the HomeScreen', () async {
      await driver.getText(find.text(my_strings.topTextHome));
    });

    test('pressing "SOLVE WITH CAMERA" button on HomeScreen brings us to the SolveWithCameraScreen',
        () async {
      await pressSolveWithCameraButton();

      await driver.getText(find.text(my_strings.topTextTakingPhoto));
    });

    test('pressing "SOLVE WITH TOUCH" button on HomeScreen brings us to the SolveWithTouchScreen',
        () async {
      await pressSolveWithTouchButton();

      await driver.getText(find.text(my_strings.topTextNoTileSelected));
    });

    test('pressing "JUST PLAY" button on HomeScreen brings us to the JustPlayScreen', () async {
      await pressJustPlayButton();

      await driver.getText(find.text(my_strings.topTextNoTileSelected));
    });

    test('pressing "Help" on SolveWithCameraScreen takes you to SolveWithCameraHelpScreen',
        () async {
      await pressSolveWithCameraButton();

      await pressHelpOnDropDownMenu('SolveWithCameraScreenDropDownMenuWidget');
      await driver.getText(find.text('1. Align your sudoku with the camera'));
    });

    test('pressing "Help" on SolveWithTouchScreen takes you to SolveWithTouchHelpScreen', () async {
      await pressSolveWithTouchButton();

      await pressHelpOnDropDownMenu('SolveWithTouchScreenDropDownMenuWidget');
      await driver.getText(find.text('1. Touch a tile to select it'));
    });

    test('pressing "Help" on JustPlayScreen takes you to JustPlayHelpScreen', () async {
      await pressJustPlayButton();

      await pressHelpOnDropDownMenu('JustPlayScreenDropDownMenuWidget');
      await driver.getText(find.text('1. Touch a tile to select it'));
    });
  });
}
