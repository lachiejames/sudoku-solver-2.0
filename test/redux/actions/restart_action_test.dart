import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';

void main() {
  AppState state;
  TileKey tileKey = TileKey(row: 1, col: 1);

  void dispatchActionAndUpdateState(dynamic action) {
    Redux.store.dispatch(action);
    state = Redux.store.state;
  }

  setUp(() {
    Redux.init();
    state = Redux.store.state;
  });

  group('RestartAction ->', () {
    test('removes all values from non-original tiles', () {
      state.tileStateMap[tileKey] = state.tileStateMap[tileKey].copyWith(
        value: 5,
      );
      dispatchActionAndUpdateState(RestartAction());
      state.tileStateMap.forEach((tk, tileState) {
        expect(tileState.value, null);
      });
    });

    test('will not remove values from original tiles', () {
      state.tileStateMap[tileKey] = state.tileStateMap[tileKey].copyWith(
        isOriginalTile: true,
        value: 5,
      );
      dispatchActionAndUpdateState(RestartAction());
      state.tileStateMap.forEach((tk, tileState) {
        if (tileKey == tk) {
          expect(tileState.value, 5);
        } else {
          expect(tileState.value, null);
        }
      });
    });

    test('sets gameState to default', () async {
      dispatchActionAndUpdateState(SolveButtonPressedAction());
      expect(state.gameState, GameState.IsSolving);

      await Future.delayed(Duration(milliseconds: 1000));

      dispatchActionAndUpdateState(RestartAction());
      expect(state.gameState, GameState.Default);
    });

    test('sets topText to "Pick a tile"', () {
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));
      expect(state.topTextState.text, MyStrings.topTextPickANumber);

      dispatchActionAndUpdateState(RestartAction());
      expect(state.topTextState.text, MyStrings.topTextPickATile);
      expect(state.topTextState.color, MyColors.white);
    });

    test('makes all numberStates inactive', () {
      dispatchActionAndUpdateState(TileSelectedAction(state.tileStateMap[tileKey]));

      state.numberStateList.forEach((numberState) {
        expect(numberState.isActive, true);
      });
      dispatchActionAndUpdateState(RestartAction());

      state.numberStateList.forEach((numberState) {
        expect(numberState.isActive, false);
      });
    });
  });
}
