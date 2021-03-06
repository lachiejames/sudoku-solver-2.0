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

  group('NumberPressedAction ->', () {
    const TileKey tileKey = TileKey(row: 6, col: 9);
    NumberState pressedNumber;

    setUp(() {
      // Need a tile to be selected before add a number
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));
      pressedNumber = state.numberStateList[6];
    });

    test('sets tile.value to selected number', () {
      expect(state.tileStateMap[tileKey].value, null);

      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

      expect(state.tileStateMap[tileKey].value, 7);
    });

    test('sets tile.value to selected number, even if tile.value was not null before', () {
      expect(state.tileStateMap[tileKey].value, null);

      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));
      expect(state.tileStateMap[tileKey].value, 7);

      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));
      pressedNumber = state.numberStateList[1];
      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));
      expect(state.tileStateMap[tileKey].value, 2);
    });

    test('sets tile.isSelected to false', () {
      expect(state.tileStateMap[tileKey].isSelected, true);

      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

      expect(state.tileStateMap[tileKey].isSelected, false);
    });

    test('all numberStates are now unactive', () {
      final List<NumberState> prevNumberStateList = state.numberStateList;
      for (final NumberState numberState in prevNumberStateList) {
        expect(numberState.isActive, true);
      }

      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

      final List<NumberState> nextNumberStateList = state.numberStateList;
      for (final NumberState numberState in nextNumberStateList) {
        expect(numberState.isActive, false);
      }
    });

    test('topText displays "Pick a tile" in white', () {
      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

      expect(state.topTextState.text, 'Pick a tile');
      expect(state.topTextState.color, white);
    });
  });
}
