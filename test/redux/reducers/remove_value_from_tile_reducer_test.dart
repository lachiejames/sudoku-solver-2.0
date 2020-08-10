import 'dart:collection';
import 'package:flutter_test/flutter_test.dart';
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

  group('RemoveValueFromTileAction & removeValueFromTileReducer ->', () {
    TileKey tileKey = TileKey(row: 6, col: 9);

    setUp(() {
      // Need a tile to have a number first
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));
      dispatchActionAndUpdateState(NumberPressedAction(state.numberStateList[3]));
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));
    });

    test('tileState replaced with new state', () {
      TileState prevTileState = state.tileStateMap[tileKey];

      dispatchActionAndUpdateState(RemoveValueFromTileAction(state.tileStateMap[tileKey]));

      TileState nextTileState = state.tileStateMap[tileKey];
      expect(prevTileState == nextTileState, false);
    });

    test('tileStateMap replaced with new state', () {
      HashMap<TileKey, TileState> prevTileStateMap = state.tileStateMap;

      dispatchActionAndUpdateState(RemoveValueFromTileAction(state.tileStateMap[tileKey]));

      HashMap<TileKey, TileState> nextTileStateMap = state.tileStateMap;
      expect(prevTileStateMap == nextTileStateMap, false);
    });

    test('numberStateList replaced with new state', () {
      List<NumberState> prevNumberStateList = state.numberStateList;

      dispatchActionAndUpdateState(RemoveValueFromTileAction(state.tileStateMap[tileKey]));

      List<NumberState> nextNumberStateList = state.numberStateList;
      expect(prevNumberStateList == nextNumberStateList, false);
    });

    test('sets tile.isTapped to false', () {
      expect(state.tileStateMap[tileKey].isTapped, true);

      dispatchActionAndUpdateState(RemoveValueFromTileAction(state.tileStateMap[tileKey]));

      expect(state.tileStateMap[tileKey].isTapped, false);
    });

    test('sets state.selectedTile to null', () {
      expect(state.hasSelectedTile, true);

      dispatchActionAndUpdateState(RemoveValueFromTileAction(state.tileStateMap[tileKey]));

      expect(state.hasSelectedTile, false);
    });

    test('removes the tiles value', () {
      expect(state.tileStateMap[tileKey].value, 4);
      dispatchActionAndUpdateState(RemoveValueFromTileAction(state.tileStateMap[tileKey]));
      expect(state.tileStateMap[tileKey].value, null);
    });

    test('tileStateMap is the same as the old tileStateMap, except for updated tileState', () {
      HashMap<TileKey, TileState> prevTileStateMap = state.tileStateMap;

      dispatchActionAndUpdateState(RemoveValueFromTileAction(state.tileStateMap[tileKey]));

      HashMap<TileKey, TileState> nextTileStateMap = state.tileStateMap;
      for (int row = 1; row <= 9; row++) {
        for (int col = 1; col <= 9; col++) {
          if (row == tileKey.row && col == tileKey.col) {
            expect(prevTileStateMap[TileKey(row: row, col: col)] == nextTileStateMap[TileKey(row: row, col: col)], false);
          } else {
            expect(prevTileStateMap[TileKey(row: row, col: col)] == nextTileStateMap[TileKey(row: row, col: col)], true);
          }
        }
      }
    });

    test('all numberStates are now unactive', () {
      List<NumberState> prevNumberStateList = state.numberStateList;
      for (NumberState numberState in prevNumberStateList) {
        expect(numberState.isActive, true);
      }

      dispatchActionAndUpdateState(RemoveValueFromTileAction(state.tileStateMap[tileKey]));

      List<NumberState> nextNumberStateList = state.numberStateList;
      for (NumberState numberState in nextNumberStateList) {
        expect(numberState.isActive, false);
      }
    });
  });
}
