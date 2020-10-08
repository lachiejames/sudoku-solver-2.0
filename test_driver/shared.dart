library shared;

import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:path/path.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

FlutterDriver driver;

Future<void> initTests() async {
  await grantAppPermissions();
  driver = await FlutterDriver.connect(dartVmServiceUrl: my_strings.dartVMServiceUrl);
  await hotRestart();
}

Future<void> grantAppPermissions() async {
  final envVars = Platform.environment;
  final adbPath = join(
    envVars['ANDROID_SDK_ROOT'] ?? envVars['ANDROID_HOME'],
    'platform-tools',
    Platform.isWindows ? 'adb.exe' : 'adb',
  );
  await Process.run(adbPath, ['shell', 'pm', 'grant', 'com.lachie.sudoku_solver_2', 'android.permission.CAMERA']);
  await Process.run(adbPath, ['shell', 'pm', 'grant', 'com.lachie.sudoku_solver_2', 'android.permission.RECORD_AUDIO']);
}

Future<void> pressBackButton() async {
  await Process.run(
    'adb',
    <String>['shell', 'input', 'keyevent', 'KEYCODE_BACK'],
    runInShell: true,
  );
}

Future<void> hotRestart() async {
  await driver.requestData(my_strings.hotRestart);
}

Future<void> waitForThenTap(SerializableFinder finder) async {
  await driver.waitFor(finder);
  await driver.tap(finder);
}

void navigateToSolveWithCameraScreen() async {
  await waitForThenTap(find.text(my_strings.solveWithCameraButtonText));
  await driver.waitFor(find.text(my_strings.solveWithCameraScreenName));
}

void navigateToSolveWithTouchScreen() async {
  await waitForThenTap(find.text(my_strings.solveWithTouchButtonText));
  await driver.waitFor(find.text(my_strings.solveWithTouchScreenName));
}

void navigateToJustPlayScreen() async {
  await waitForThenTap(find.text(my_strings.justPlayButtonText));
  await driver.waitFor(find.text(my_strings.topTextNoTileSelected));

  // May load with the wrong sudoku when restarting, causing test failures
  bool needsAnotherRestart = (await getNumberOnTile(TileKey(row: 1, col: 1)) != 5);
  if (needsAnotherRestart) {
    await hotRestart();
    await navigateToJustPlayScreen();
  }
}

void pressSolveWithCameraButton() async {
  await waitForThenTap(find.text(my_strings.solveWithCameraButtonText));
}

void pressSolveWithTouchButton() async {
  await waitForThenTap(find.text(my_strings.solveWithTouchButtonText));
}

void pressJustPlayButton() async {
  await waitForThenTap(find.text(my_strings.justPlayButtonText));
}

void pressHelpOnDropDownMenu(String dropDownMenuType) async {
  await waitForThenTap(find.byType(dropDownMenuType));
  await waitForThenTap(find.text(my_strings.dropDownMenuOption2));
}

void pressRestartOnDropDownMenu(String dropDownMenuType) async {
  await waitForThenTap(find.byType(dropDownMenuType));
  await waitForThenTap(find.text(my_strings.dropDownMenuOption1));
}

void tapTile(TileKey tileKey) async {
  await waitForThenTap(find.byValueKey('${tileKey.toString()}'));
}

void doubleTapTile(TileKey tileKey) async {
  await tapTile(tileKey);
  await tapTile(tileKey);
}

void tapNumber(int number) async {
  await waitForThenTap(find.byValueKey('Number($number)'));
}

void addNumberToTile(int number, TileKey tileKey) async {
  await tapTile(tileKey);
  await tapNumber(number);
}

void tapNewGameButton() async {
  await waitForThenTap(find.text('NEW GAME'));
}

Future<void> expectNumbersAre({String color}) async {
  for (int number = 1; number <= 9; number++) {
    await expectNumberPropertiesToBe(number: number, color: color);
  }
}

Future<int> getNumberOnTile(TileKey tileKey) async {
  await driver.waitFor(find.byValueKey('${tileKey.toString()}_text'));
  String tileText = await driver.getText(find.byValueKey('${tileKey.toString()}_text'));

  if (tileText == "") {
    return null;
  } else {
    return int.parse(tileText);
  }
}

Future<void> expectTileIs({
  @required TileKey tileKey,
  @required String color,
  @required String textColor,
  @required bool hasX,
}) async {
  await driver.waitFor(find.byValueKey('$tileKey - color:$color - textColor:$textColor - X:$hasX'));
}

Future<void> expectNumberPropertiesToBe({int number, String color}) async {
  await driver.waitFor(find.byValueKey('Number($number) - color:$color'));
}

void expectNumberOnTileToBe(int number, TileKey tileKey) async {
  int numberOnTile = await getNumberOnTile(tileKey);
  expect(numberOnTile == number, true);
}

Future<void> verifyInitialGameTiles(List<List<int>> game) async {
  for (int row = 1; row <= 9; row++) {
    for (int col = 1; col <= 9; col++) {
      await expectNumberOnTileToBe(game[row - 1][col - 1], TileKey(row: row, col: col));
    }
  }
}

Future<void> playGame(List<List<int>> game) async {
  for (int row = 1; row <= 9; row++) {
    for (int col = 1; col <= 9; col++) {
      int numberOnTile = await getNumberOnTile(TileKey(row: row, col: col));
      if (numberOnTile == null) {
        await addNumberToTile(game[row - 1][col - 1], TileKey(row: row, col: col));
      }
    }
  }
}
