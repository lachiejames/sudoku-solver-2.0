import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

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

  group('SolveSudokuAction ->', () {
    group('before solved ->', () {
      test('sets gameState to isSolving', () {
        expect(state.gameState, GameState.normal);
        dispatchActionAndUpdateState(SolveSudokuAction());
        expect(state.gameState, GameState.isSolving);
      });

      test('sets topText to "AI thinking..." in white', () {
        expect(state.topTextState.text, topTextNoTileSelected);
        dispatchActionAndUpdateState(SolveSudokuAction());
        expect(state.topTextState.text, topTextWhenSolving);
        expect(state.topTextState.color, white);
      });
    });

    group('after solved ->', () {
      test('sets gameState to solved', () async {
        dispatchActionAndUpdateState(SolveSudokuAction());

        // Takes a second to solve.  Gotta update the state too
        await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
        state = Redux.store.state;

        expect(state.gameState, GameState.solved);
      });

      test('sets topText to "SOLVED" in green', () async {
        dispatchActionAndUpdateState(SolveSudokuAction());

        // Takes a second to solve.  Gotta update the state too
        await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
        state = Redux.store.state;

        expect(state.topTextState.text, topTextSolved);
        expect(state.topTextState.color, green);
      });
    });
  });
}
