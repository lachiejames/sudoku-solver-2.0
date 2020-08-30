import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:test/test.dart';
import 'package:path/path.dart';

void main() async {
  FlutterDriver driver;

  Future<void> grantPermissions() async {
    final envVars = Platform.environment;
    final adbPath = join(
      envVars['ANDROID_SDK_ROOT'] ?? envVars['ANDROID_HOME'],
      'platform-tools',
      Platform.isWindows ? 'adb.exe' : 'adb',
    );
    await Process.run(adbPath, [
      'shell',
      'pm',
      'grant',
      'com.lachie.sudoku_solver_2', // replace with your app id
      'android.permission.CAMERA'
    ]);
    await Process.run(adbPath, [
      'shell',
      'pm',
      'grant',
      'com.lachie.sudoku_solver_2', // replace with your app id
      'android.permission.RECORD_AUDIO'
    ]);
  }

  setUpAll(() async {
    await grantPermissions();
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
  });

  group('Run integration tests -', () {
    group('Screen navigation tests -', () {
      // Restart app at beginning of each test
      setUp(() async {
        print('before  restart');
        await driver.requestData(MyStrings.hotRestart);
        print('before  restart');
      });
      test('we start on the HomeScreen', () async {
        await driver.getText(find.text(MyStrings.topTextHome));
      });

      test('pressing "SOLVE WITH CAMERA" button on HomeScreen brings us to the SolveWithCameraScreen', () async {
        await driver.tap(find.text(MyStrings.solveWithCameraButtonText));
        await driver.getText(find.text(MyStrings.topTextTakingPhoto));
      });

      test('pressing "SOLVE WITH TOUCH" button on HomeScreen brings us to the SolveWithTouchScreen', () async {
        await driver.tap(find.text(MyStrings.solveWithTouchButtonText));
        await driver.getText(find.text(MyStrings.topTextNoTileSelected));
      });

      test('pressing "JUST PLAY" button on HomeScreen brings us to the JustPlayScreen', () async {
        await driver.tap(find.text(MyStrings.justPlayButtonText));
        await driver.getText(find.text(MyStrings.topTextNoTileSelected));
      });

      test('pressing "Help" on SolveWithCameraScreen takes you to SolveWithCameraHelpScreen', () async {
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

    group('SolveWithCameraScreen tests -', () {
      setUp(() async {
        await driver.requestData(MyStrings.hotRestart);
        await driver.tap(find.text(MyStrings.solveWithCameraButtonText));
        await driver.getText(find.text(MyStrings.topTextTakingPhoto));
      });
      test('pressing "TAKE PHOTO" replaces the CameraWidget with a SudokuWidget', () async {
        print('running my test');
      });
    });
  });
}
