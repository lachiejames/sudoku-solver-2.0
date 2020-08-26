import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';

void main() {
  AppState state;
  TileKey tileKey1 = TileKey(row: 1, col: 1);
  TileKey tileKey2 = TileKey(row: 1, col: 3);

  void dispatchActionAndUpdateState(dynamic action) {
    Redux.store.dispatch(action);
    state = Redux.store.state;
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Redux.init();
    state = Redux.store.state;
  });

  group('LoadPlayScreenWithSudokuAction ->', () {
    test('fills tileStateMap with values', () {
      dispatchActionAndUpdateState(LoadPlayScreenWithSudokuAction(0));
      expect(state.tileStateMap[tileKey1].value, 5);
      expect(state.tileStateMap[tileKey2].value, null);
    });

    test('each value loaded becomes an originalTile in tileStateMap', () {
      dispatchActionAndUpdateState(LoadPlayScreenWithSudokuAction(0));
      expect(state.tileStateMap[tileKey1].isOriginalTile, true);
      expect(state.tileStateMap[tileKey2].isOriginalTile, false);
    });
  });
}
