import 'dart:async';
import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:path/path.dart';

void main() {
  FlutterDriver driver;
  StreamSubscription streamSubscription;

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
      'com.lachie.sudoku_solver_2',
      'android.permission.CAMERA'
    ]);
    await Process.run(adbPath, [
      'shell',
      'pm',
      'grant',
      'com.lachie.sudoku_solver_2',
      'android.permission.RECORD_AUDIO'
    ]);
  }

  setUpAll(() async {
    await grantPermissions();
    driver = await FlutterDriver.connect();
    streamSubscription = driver.serviceClient.onIsolateRunnable.asBroadcastStream().listen((isolateRef) {
      isolateRef.resume();
    });
    await driver.waitUntilFirstFrameRasterized();
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
    if (streamSubscription != null) streamSubscription.cancel();
  });

  group('HomeScreen tests -', () {
    test('pressing JUST PLAY button brings us to the JustPlayScreen', () async {
      await driver.getText(find.text('How would you like it to be solved?'));
      await driver.tap(find.text('Just Play'));
      await driver.getText(find.text('Pick a tile'));
    });
  });
}
