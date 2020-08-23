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

  // Restart app at beginning of each test
  setUp(() async {
    if (driver != null) await driver.requestData(MyStrings.hotRestart);
  });

  group('HomeScreen tests -', () {
    test('pressing "SOLVE WITH CAMERA" button brings us to the SolveWithCameraScreen', () async {
      await driver.tap(find.text(MyStrings.solveWithCameraButtonText));
      await driver.getText(find.text(MyStrings.topTextTakingPhoto));
    });
  });
}
