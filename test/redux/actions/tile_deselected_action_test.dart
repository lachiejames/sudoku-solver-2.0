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

  group('TileDeselectedAction ->', () {
    TileKey tileKey = TileKey(row: 6, col: 9);

    setUp(() {
      // Need a tile to be selected before we deselect it
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));
    });

    test('tileState replaced with new state', () {
      TileState prevTileState = state.tileStateMap[tileKey];

      dispatchActionAndUpdateState(TileDeselectedAction(state.tileStateMap[tileKey]));

      TileState nextTileState = state.tileStateMap[tileKey];
      expect(prevTileState == nextTileState, false);
    });

    test('tileStateMap replaced with new state', () {
      HashMap<TileKey, TileState> prevTileStateMap = state.tileStateMap;

      dispatchActionAndUpdateState(TileDeselectedAction(state.tileStateMap[tileKey]));

      HashMap<TileKey, TileState> nextTileStateMap = state.tileStateMap;
      expect(prevTileStateMap == nextTileStateMap, false);
    });

    test('numberStateList replaced with new state', () {
      List<NumberState> prevNumberStateList = state.numberStateList;

      dispatchActionAndUpdateState(TileDeselectedAction(state.tileStateMap[tileKey]));

      List<NumberState> nextNumberStateList = state.numberStateList;
      expect(prevNumberStateList == nextNumberStateList, false);
    });

    test('sets tile.isTapped to false', () {
      expect(state.tileStateMap[tileKey].isTapped, true);

      dispatchActionAndUpdateState(TileDeselectedAction(state.tileStateMap[tileKey]));

      expect(state.tileStateMap[tileKey].isTapped, false);
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
      expect(state.topTextState.color, MyColors.white);
    });
  });
}
