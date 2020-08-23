import 'dart:async';
import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;

  Future<void> pressBackButton() async {
    await Process.run(
      'adb',
      <String>['shell', 'input', 'keyevent', 'KEYCODE_BACK'],
      runInShell: true,
    );
  }

  setUpAll(() async {
    driver = await FlutterDriver.connect(dartVmServiceUrl: 'http://127.0.0.1:8888/');
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
  });

  // Restart app at beginning of each test
  setUp(() async {
    if (driver != null) await driver.requestData('restart');
  });
  
  group('HomeScreen tests -', () {

    test('pressing "Solve With Camera" button brings us to the SolveWithCameraScreen', () async {
      await driver.tap(find.text('Solve With Camera'));
      await driver.getText(find.text('Align with camera'));

      // Back to homeScreen
      await pressBackButton();
    });
  });
}
