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

  group('HomeScreen tests -', () {
    test('we start on the HomeScreen', () async {
      await driver.getText(find.text('How would you like it to be solved?'));
    });

    test('pressing "Solve With Camera" button brings us to the SolveWithCameraScreen', () async {
      await driver.tap(find.text('Solve With Camera'));
      await driver.getText(find.text('Align with camera'));

      // Back to homeScreen
      await pressBackButton();
    });

    test('pressing "Solve With Touch" button brings us to the SolveWithTouchScreen', () async {
      await driver.tap(find.text('Solve With Touch'));
      await driver.getText(find.text('Pick a tile'));

      // Back to homeScreen
      await pressBackButton();
    });

    test('pressing "Just Play" button brings us to the JustPlayScreen', () async {
      await driver.tap(find.text('Just Play'));
      await driver.getText(find.text('Pick a tile'));

      // Back to homeScreen
      await pressBackButton();
    });
  });
}
