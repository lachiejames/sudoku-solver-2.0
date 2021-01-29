library shared;

import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:path/path.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

const  Timeout defaultTimeout = Timeout(Duration(seconds: 60));
const  Timeout longTimeout = Timeout(Duration(seconds: 300));
FlutterDriver driver;

Future<void> initTests() async {
  await grantAppPermissions();
  driver = await FlutterDriver.connect(dartVmServiceUrl: 'http://127.0.0.1:8888/');
  await hotRestart();
}

Future<void> grantAppPermissions() async {
  final Map<String, String> envVars = Platform.environment;
  final String adbPath = join(
    envVars['ANDROID_SDK_ROOT'] ?? envVars['ANDROID_HOME'],
    'platform-tools',
    Platform.isWindows ? 'adb.exe' : 'adb',
  );
  await Process.run(adbPath, <String>['shell', 'pm', 'grant', 'com.lachie.sudoku_solver_2', 'android.permission.CAMERA']);
  await Process.run(adbPath, <String>['shell', 'pm', 'grant', 'com.lachie.sudoku_solver_2', 'android.permission.RECORD_AUDIO']);
}

Future<void> pressBackButton() async {
  await Process.run(
    'adb',
    <String>['shell', 'input', 'keyevent', 'KEYCODE_BACK'],
    runInShell: true,
  );
}

Future<void> hotRestart() async {
  await driver.requestData('restart');
  await driver.waitUntilNoTransientCallbacks();
}

Future<void> waitForThenTap(SerializableFinder finder) async {
  await waitToAppear(finder);
  await driver.tap(finder);
  await driver.waitUntilNoTransientCallbacks();
}

Future<void> navigateToSolveWithCameraScreen() async {
  await waitForThenTap(find.text('SOLVE WITH CAMERA'));

  await driver.runUnsynchronized(() async {
    await waitToAppear(find.text('Camera'));
  });
}

Future<void> navigateToSolveWithTouchScreen() async {
  await waitForThenTap(find.text('SOLVE WITH TOUCH'));
  await waitToAppear(find.text('Touch'));
}

Future<void> navigateToJustPlayScreen() async {
  await waitForThenTap(find.text('JUST PLAY'));
  await waitToAppear(find.text('Pick a tile'));

  // May load with the wrong sudoku when restarting, causing test failures
  final bool needsAnotherRestart = await getNumberOnTile(const TileKey(row: 1, col: 1)) != 5;
  if (needsAnotherRestart) {
    await hotRestart();
    await navigateToJustPlayScreen();
  }
}

Future<void> pressSolveWithCameraButton() async {
  await waitForThenTap(find.text('SOLVE WITH CAMERA'));
}

Future<void> pressSolveWithTouchButton() async {
  await waitForThenTap(find.text('SOLVE WITH TOUCH'));
}

Future<void> pressJustPlayButton() async {
  await waitForThenTap(find.text('JUST PLAY'));
}

Future<void> pressHelpOnDropDownMenu(String dropDownMenuType) async {
  await waitForThenTap(find.byType(dropDownMenuType));
  await waitForThenTap(find.text('Help'));
}

Future<void> pressRestartOnDropDownMenu(String dropDownMenuType) async {
  await waitForThenTap(find.byType(dropDownMenuType));
  await waitForThenTap(find.text('Restart'));
}

Future<void> tapTile(TileKey tileKey) async {
  await waitForThenTap(find.byValueKey('$tileKey'));
}

Future<void> doubleTapTile(TileKey tileKey) async {
  await tapTile(tileKey);
  await tapTile(tileKey);
}

Future<void> tapNumber(int number) async {
  await waitForThenTap(find.byValueKey('Number($number)'));
}

Future<void> addNumberToTile(int number, TileKey tileKey) async {
  await tapTile(tileKey);
  await tapNumber(number);
}

Future<void> tapNewGameButton() async {
  await waitForThenTap(find.text('NEW GAME'));
}

Future<void> expectNumbersAre({String color}) async {
  for (int number = 1; number <= 9; number++) {
    await expectNumberPropertiesToBe(number: number, color: color);
  }
}

Future<int> getNumberOnTile(TileKey tileKey) async {
  await waitToAppear(find.byValueKey('${tileKey.toString()}_text'));
  final String tileText = await driver.getText(find.byValueKey('${tileKey.toString()}_text'));

  if (tileText == '') {
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
  await driver.waitUntilNoTransientCallbacks();
  await waitToAppear(find.byValueKey('$tileKey - color:$color - textColor:$textColor - X:$hasX'));
}

Future<void> expectNumberPropertiesToBe({int number, String color}) async {
  await driver.waitUntilNoTransientCallbacks();
  await waitToAppear(find.byValueKey('Number($number) - color:$color'));
}

Future<void> expectNumberOnTileToBe(int number, TileKey tileKey) async {
  final int numberOnTile = await getNumberOnTile(tileKey);
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
      final int numberOnTile = await getNumberOnTile(TileKey(row: row, col: col));
      if (numberOnTile == null) {
        await addNumberToTile(game[row - 1][col - 1], TileKey(row: row, col: col));
      }
    }
  }
}

Future<void> addSudoku(List<List<int>> game) async {
  for (int row = 1; row <= 9; row++) {
    for (int col = 1; col <= 9; col++) {
      final int nextValue = game[row - 1][col - 1];
      if (nextValue != null) {
        await addNumberToTile(nextValue, TileKey(row: row, col: col));
      }
    }
  }
}

Future<void> expectButtonPropertiesAre({
  @required String text,
  @required String color,
  @required String tappable,
}) async {
  await waitToAppear(find.byValueKey('text:$text - color:$color - tappable:$tappable'));
}

Future<void> waitToAppear(SerializableFinder finder) async {
  await driver.waitUntilNoTransientCallbacks();
  await driver.waitFor(finder);
}

Future<void> waitToDisappear(SerializableFinder finder) async {
  await driver.waitUntilNoTransientCallbacks();
  await driver.waitForAbsent(finder);
}
