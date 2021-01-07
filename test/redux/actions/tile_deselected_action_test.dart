import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';

void main() {
  AppState state;

  void dispatchActionAndUpdateState(dynamic action) {
    Redux.store.dispatch(action);
    state = Redux.store.state;
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Redux.init();
    state = Redux.store.state;
  });

  group('TileDeselectedAction ->', () {
    TileKey tileKey = TileKey(row: 6, col: 9);

    setUp(() {
      // Need a tile to be selected before we deselect it
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));
    });

    test('sets tile.isSelected to false', () {
      expect(state.tileStateMap[tileKey].isSelected, true);

      dispatchActionAndUpdateState(TileDeselectedAction(state.tileStateMap[tileKey]));

      expect(state.tileStateMap[tileKey].isSelected, false);
    });

    test('all numberStates are now unactive', () {
      List<NumberState> prevNumberStateList = state.numberStateList;
      for (NumberState numberState in prevNumberStateList) {
        expect(numberState.isActive, true);
      }

      dispatchActionAndUpdateState(TileDeselectedAction(state.tileStateMap[tileKey]));

      List<NumberState> nextNumberStateList = state.numberStateList;
      for (NumberState numberState in nextNumberStateList) {
        expect(numberState.isActive, false);
      }
    });

    test('topText displays "Pick a tile" in white', () {
      dispatchActionAndUpdateState(TileDeselectedAction(state.tileStateMap[tileKey]));

      expect(state.topTextState.text, 'Pick a tile');
      expect(state.topTextState.color, constants.white);
    });
  });
}
