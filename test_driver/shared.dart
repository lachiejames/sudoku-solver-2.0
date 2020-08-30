import 'dart:io';
import 'package:path/path.dart';

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
