import 'dart:collection';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/store.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

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

  group('Redux initialisation', () {
    test('AppState correctly initialised', () {
      expect(state, isNotNull);
      expect(state.tileStateMap, isNotNull);
      expect(state.numberStateList, isNotNull);
      expect(state.hasSelectedTile, false);
      expect(state.topTextState, isNotNull);
    });

    test('AppState.tileStateMap correctly initialised', () {
      HashMap<TileKey, TileState> tileStateMap = state.tileStateMap;
      expect(tileStateMap.length, 81);
      expect(tileStateMap.containsKey(TileKey(row: 6, col: 9)), true);
      expect(tileStateMap[TileKey(row: 6, col: 9)].toString(), 'TileState(row=6, col=9, value=null, isTapped=false)');
    });

    test('AppState.numberStateMap correctly initialised', () {
      List<NumberState> numberStateList = state.numberStateList;
      expect(numberStateList.length, 9);
      expect(numberStateList[8].toString(), 'NumberState(9)');
    });

    test('AppState.topTextState correctly initialised', () {
      TopTextState topTextState = state.topTextState;
      expect(topTextState.text, 'Pick a tile');
    });
  });

  group('TileSelectedAction & tileSelectedReducer', () {
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

  group('TileDeselectedAction & tileDeselectedReducer', () {
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

    test('sets state.selectedTile to null', () {
      expect(state.hasSelectedTile, true);

      dispatchActionAndUpdateState(TileDeselectedAction(state.tileStateMap[tileKey]));

      expect(state.hasSelectedTile, false);
    });

    test('tileStateMap is the same as the old tileStateMap, except for updated tileState', () {
      HashMap<TileKey, TileState> prevTileStateMap = state.tileStateMap;

      dispatchActionAndUpdateState(TileDeselectedAction(state.tileStateMap[tileKey]));

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

      dispatchActionAndUpdateState(TileDeselectedAction(state.tileStateMap[tileKey]));

      List<NumberState> nextNumberStateList = state.numberStateList;
      for (NumberState numberState in nextNumberStateList) {
        expect(numberState.isActive, false);
      }
    });
  });

  group('RemoveValueFromTileAction & removeValueFromTileReducer', () {
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

  group('NumberPressedAction & NumberPressedReducer', () {
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

    test('sets state.selectedTile to false', () {
      expect(state.hasSelectedTile, true);

      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

      expect(state.hasSelectedTile, false);
    });

    test('tileStateMap is the same as the old tileStateMap, except for updated tileState', () {
      HashMap<TileKey, TileState> prevTileStateMap = state.tileStateMap;

      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

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

      dispatchActionAndUpdateState(NumberPressedAction(pressedNumber));

      List<NumberState> nextNumberStateList = state.numberStateList;
      for (NumberState numberState in nextNumberStateList) {
        expect(numberState.isActive, false);
      }
    });
  });
}
