import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect(dartVmServiceUrl: MyStrings.dartVMServiceURL);
  });

  tearDownAll(() async {
    if (driver != null) await driver.close();
  });

  group('SolveWithCameraScreen tests -', () {
    // Restart app at beginning of each test
    setUp(() async {
      await driver.requestData(MyStrings.hotRestart);
      await driver.tap(find.text(MyStrings.solveWithCameraButtonText));
      await driver.getText(find.text(MyStrings.topTextTakingPhoto));
    });
    // test('pressing "TAKE PHOTO" replaces the CameraWidget with a SudokuWidget', () async {
    //   await driver.waitFor(find.byType('CameraWidget'));
    //   await driver.tap(find.text(MyStrings.takePhotoButtonText));
    //   await driver.waitFor(find.byType('SudokuWidget'));
    // });
  });
}
