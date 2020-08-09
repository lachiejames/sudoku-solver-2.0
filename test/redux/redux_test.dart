import 'dart:collection';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

void main() {
  AppState state;

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

}
