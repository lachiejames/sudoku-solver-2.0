import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';

import '../../constants/test_constants.dart';

void main() {
  AppState state;

  void dispatchActionAndUpdateState(dynamic action) {
    Redux.store.dispatch(action);
    state = Redux.store.state;
  }

  setUp(() async {
    setMockMethodsForUnitTests();
    await Redux.init();
    state = Redux.store.state;
  });

  group('TileSelectedAction ->', () {
    const TileKey tileKey = TileKey(row: 6, col: 9);

    test('sets tile.isSelected to true', () {
      expect(state.tileStateMap[tileKey].isSelected, false);

      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));

      expect(state.tileStateMap[tileKey].isSelected, true);
    });

    test('all numberStates are now active', () {
      final List<NumberState> prevNumberStateList = state.numberStateList;
      for (final NumberState numberState in prevNumberStateList) {
        expect(numberState.isActive, false);
      }

      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));

      final List<NumberState> nextNumberStateList = state.numberStateList;
      for (final NumberState numberState in nextNumberStateList) {
        expect(numberState.isActive, true);
      }
    });

    test('tapping another tile will deselect previous tile', () {
      expect(state.tileStateMap[tileKey].isSelected, false);
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));
      expect(state.tileStateMap[tileKey].isSelected, true);

      const TileKey newTileKey = TileKey(row: 3, col: 4);
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[newTileKey]));
      expect(state.tileStateMap[newTileKey].isSelected, true);
      expect(state.tileStateMap[tileKey].isSelected, false);
    });

    test('topText displays "Pick a number" in white', () {
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));

      expect(state.topTextState.text, 'Pick a number');
      expect(state.topTextState.color, white);
    });
  });
}
