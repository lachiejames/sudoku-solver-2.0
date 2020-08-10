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

  group('TileSelectedAction & tileSelectedReducer ->', () {
    TileKey tileKey = TileKey(row: 6, col: 9);

    test('tileState replaced with new state', () {
      TileState prevTileState = state.tileStateMap[tileKey];

      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));

      TileState nextTileState = state.tileStateMap[tileKey];
      expect(prevTileState == nextTileState, false);
    });

    test('tileStateMap replaced with new state', () {
      HashMap<TileKey, TileState> prevTileStateMap = state.tileStateMap;

      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));

      HashMap<TileKey, TileState> nextTileStateMap = state.tileStateMap;
      expect(prevTileStateMap == nextTileStateMap, false);
    });

    test('numberStateList replaced with new state', () {
      List<NumberState> prevNumberStateList = state.numberStateList;

      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));

      List<NumberState> nextNumberStateList = state.numberStateList;
      expect(prevNumberStateList == nextNumberStateList, false);
    });

    test('sets tile.isTapped to true', () {
      expect(state.tileStateMap[tileKey].isTapped, false);

      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));

      expect(state.tileStateMap[tileKey].isTapped, true);
    });

    test('sets state.selectedTile to the new tile', () {
      expect(state.hasSelectedTile, false);

      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));

      expect(state.hasSelectedTile, true);
    });

    test('tileStateMap is the same as the old tileStateMap, except for update tileState', () {
      HashMap<TileKey, TileState> prevTileStateMap = state.tileStateMap;

      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));

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

    test('all numberStates are now active', () {
      List<NumberState> prevNumberStateList = state.numberStateList;
      for (NumberState numberState in prevNumberStateList) {
        expect(numberState.isActive, false);
      }

      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));

      List<NumberState> nextNumberStateList = state.numberStateList;
      for (NumberState numberState in nextNumberStateList) {
        expect(numberState.isActive, true);
      }
    });

    test('tapping another tile will deselect previous tile', () {
      expect(state.tileStateMap[tileKey].isTapped, false);
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));
      expect(state.tileStateMap[tileKey].isTapped, true);
      expect(state.hasSelectedTile, true);

      TileKey newTileKey = TileKey(row: 3, col: 4);
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[newTileKey]));
      expect(state.tileStateMap[newTileKey].isTapped, true);
      expect(state.tileStateMap[tileKey].isTapped, false);
      expect(state.hasSelectedTile, true);
    });
  });
}
