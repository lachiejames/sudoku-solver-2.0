import 'dart:collection';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

void main() {
  AppState state;

  void dispatchActionAndUpdateState(dynamic action) {
    Redux.store.dispatch(action);
    state = Redux.store.state;
  }

  setUp(() {
    Redux.init();
    state = Redux.store.state;
  });

  group('NumberPressedAction ->', () {
    TileKey tileKey = TileKey(row: 6, col: 9);
    NumberState pressedNumber;

    setUp(() {
      // Need a tile to be selected before add a number
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));
      pressedNumber = state.numberStateList[6];
    });

    test('tileState replaced with new state', () {
      TileState prevTileState = state.tileStateMap[tileKey];

      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

      TileState nextTileState = state.tileStateMap[tileKey];
      expect(prevTileState == nextTileState, false);
    });

    test('tileStateMap replaced with new state', () {
      HashMap<TileKey, TileState> prevTileStateMap = state.tileStateMap;

      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

      HashMap<TileKey, TileState> nextTileStateMap = state.tileStateMap;
      expect(prevTileStateMap == nextTileStateMap, false);
    });

    test('numberStateList replaced with new state', () {
      List<NumberState> prevNumberStateList = state.numberStateList;

      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

      List<NumberState> nextNumberStateList = state.numberStateList;
      expect(prevNumberStateList == nextNumberStateList, false);
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

    test('sets tile.isTapped to false', () {
      expect(state.tileStateMap[tileKey].isTapped, true);

      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

      expect(state.tileStateMap[tileKey].isTapped, false);
    });

    test('all numberStates are now unactive', () {
      List<NumberState> prevNumberStateList = state.numberStateList;
      for (NumberState numberState in prevNumberStateList) {
        expect(numberState.isActive, true);
      }

      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

      List<NumberState> nextNumberStateList = state.numberStateList;
      for (NumberState numberState in nextNumberStateList) {
        expect(numberState.isActive, false);
      }
    });

    test('topText displays "Pick a tile" in white', () {
      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

      expect(state.topTextState.text, 'Pick a tile');
      expect(state.topTextState.color, MyColors.white);
    });

    // TODO: implement this
    test('if pressing that number solved the game, topText displays "SOLVED" in green', () {
      // dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

      // expect(state.topTextState.text, 'SOLVED');
      // expect(state.topTextState.color, MyColors.green);
    });

    // TODO: implement this
    test('if pressing that number solved the game, gameState should be SOLVED', () {
      // dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

      // expect(state.topTextState.text, 'SOLVED');
      // expect(state.topTextState.color, MyColors.green);
    });
  });
}
