import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:test/test.dart';
import 'shared.dart';

void main() async {
  FlutterDriver driver;

  setUpAll(() async {
    await grantAppPermissions();
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
  });

  group('SolveWithCameraScreen tests -', () {
    setUp(() async {
      await driver.requestData(MyStrings.hotRestart);
      await driver.tap(find.text(MyStrings.solveWithCameraButtonText));
      await driver.getText(find.text(MyStrings.topTextTakingPhoto));
    });
    test('pressing "TAKE PHOTO" replaces the CameraWidget with a SudokuWidget', () async {
    });
  });
}
