import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

void main() {
  AppState state;

  void dispatchActionAndUpdateState(dynamic action) {
    Redux.store.dispatch(action);
    state = Redux.store.state;
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    Redux.sharedPreferences = await SharedPreferences.getInstance();
    Redux.init();
    state = Redux.store.state;
  });

  group('NewGameButtonPressedAction ->', () {
    test('increments game number by 1', () {
      expect(state.gameNumber, 0);
      dispatchActionAndUpdateState(NewGameButtonPressedAction());
      expect(state.gameNumber, 1);
    });
  });
}
