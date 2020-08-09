import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/redux/store.dart';

void main() {
  AppState state;

  setUp(() async {
    await Redux.init();
    state = Redux.store.state;
  });

  test('AppState correctly initialised', () {
    expect(state,isNotNull);
  });
}
