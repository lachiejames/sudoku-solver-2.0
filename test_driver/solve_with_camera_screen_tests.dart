import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:test/test.dart';
import 'shared.dart';

void main() {
  FlutterDriver driver;

  void navigateToSolveWithCameraScreen() async {
    await waitForThenTap(find.text(my_strings.solveWithCameraButtonText));
    await driver.getText(find.text(my_strings.solveWithCameraScreenName));
  }

  group('SolveWithCameraScreen tests ->', () {
    setUpAll(() async {
      await grantAppPermissions();
      driver = await FlutterDriver.connect(dartVmServiceUrl: my_strings.dartVMServiceUrl);
      setDriver(driver);
      await hotRestart();
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    setUp(() async {
      await hotRestart();
      await navigateToSolveWithCameraScreen();
    });
    test('pressing "TAKE PHOTO" replaces the CameraWidget with a SudokuWidget', () async {});
  });
}
