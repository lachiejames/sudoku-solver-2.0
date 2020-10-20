import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'shared.dart';

void main() {
  group('SolveWithCameraScreen tests ->', () {
    setUpAll(() async {
      await initTests();
    });

    tearDownAll(() async {
      await driver.requestData(my_strings.deletePictureMock);
      if (driver != null) await driver.close();
    });

    setUp(() async {
      await hotRestart();
      await navigateToSolveWithCameraScreen();
    });
    test('pressing "TAKE PHOTO" replaces the CameraWidget with a SudokuWidget', () async {
      await driver.requestData(my_strings.setPictureMock);
      await driver.runUnsynchronized(() async {
        await Future.delayed(Duration(seconds: 3));
        await waitForThenTap(find.text('TAKE PHOTO'));
        await driver.waitFor(find.text('5'));

      });
    });
  });
}
