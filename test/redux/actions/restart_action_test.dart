import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

import '../../constants/test_constants.dart';

void main() {
  AppState state;
  const TileKey tileKey = TileKey(row: 1, col: 1);

  void dispatchActionAndUpdateState(dynamic action) {
    Redux.store.dispatch(action);
    state = Redux.store.state;
  }

  setUp(() async {
    setMockMethodsForUnitTests();
    await Redux.init();
    state = Redux.store.state;
  });

  group('RestartAction ->', () {
    test('removes all values from non-original tiles', () {
      state.tileStateMap[tileKey] = state.tileStateMap[tileKey].copyWith(
        value: 5,
      );
      dispatchActionAndUpdateState(RestartAction());
      state.tileStateMap.forEach((TileKey tk, TileState tileState) {
        expect(tileState.value, null);
      });
    });

    test('will not remove values from original tiles', () {
      state.tileStateMap[tileKey] = state.tileStateMap[tileKey].copyWith(
        isOriginalTile: true,
        value: 5,
      );
      dispatchActionAndUpdateState(RestartAction());
      state.tileStateMap.forEach((TileKey tk, TileState tileState) {
        if (tileKey == tk) {
          expect(tileState.value, 5);
        } else {
          expect(tileState.value, null);
        }
      });
    });

    test('sets gameState to default', () async {
      dispatchActionAndUpdateState(SolveSudokuAction());
      expect(state.gameState, GameState.isSolving);

      await Future<dynamic>.delayed(const Duration(milliseconds: 1000));

      dispatchActionAndUpdateState(RestartAction());
      expect(state.gameState, GameState.normal);
    });

    test('sets topText to "Pick a tile"', () {
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));
      expect(state.topTextState.text, topTextTileSelected);

      dispatchActionAndUpdateState(RestartAction());
      expect(state.topTextState.text, topTextNoTileSelected);
      expect(state.topTextState.color, white);
    });

    test('makes all numberStates inactive', () {
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));

      for (final NumberState numberState in state.numberStateList) {
        expect(numberState.isActive, true);
      }

      dispatchActionAndUpdateState(RestartAction());

      for (final NumberState numberState in state.numberStateList) {
        expect(numberState.isActive, false);
      }
    });
  });
}
