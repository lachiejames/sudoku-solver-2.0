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
    test('pressing "TAKE PHOTO" replaces the CameraWidget with a SudokuWidget', () async {});
  });
}
