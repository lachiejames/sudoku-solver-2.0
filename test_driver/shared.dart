import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:path/path.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;

Future<void> grantAppPermissions() async {
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

Future<void> hotRestart(FlutterDriver driver) async {
  await driver.waitUntilNoTransientCallbacks();
  await driver.requestData(my_strings.hotRestart);
  await driver.waitUntilNoTransientCallbacks();
}

Future<void> waitForThenTap(FlutterDriver driver, SerializableFinder finder) async {
  await driver.waitUntilNoTransientCallbacks();
  await driver.waitFor(finder);
  await driver.tap(finder);
  await driver.waitUntilNoTransientCallbacks();
}
