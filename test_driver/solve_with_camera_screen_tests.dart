import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'shared.dart';

void main() {
  group('SolveWithCameraScreen tests ->', () {
    setUpAll(() async {
      await initTests();
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    setUp(() async {
      await hotRestart();
      await navigateToSolveWithCameraScreen();
    });
    test('pressing "TAKE PHOTO" replaces the CameraWidget with a SudokuWidget', () async {
      await driver.requestData('takePicture');
      await driver.runUnsynchronized(() async {
        await Future.delayed(Duration(seconds: 3));
        await waitForThenTap(find.text('TAKE PHOTO'));
      });
    });
  });
}
