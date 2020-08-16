import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

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

  group('SolveButtonPressedAction ->', () {
    group('before solved ->', () {
      test('sets gameState to isSolving', () {
        expect(state.gameState, GameState.Default);
        dispatchActionAndUpdateState(SolveButtonPressedAction());
        expect(state.gameState, GameState.IsSolving);
      });

      test('sets topText to "AI thinking..." in white', () {
        expect(state.topTextState.text, MyStrings.topTextPickATile);
        dispatchActionAndUpdateState(SolveButtonPressedAction());
        expect(state.topTextState.text, MyStrings.topTextAiThinking);
        expect(state.topTextState.color, MyColors.white);
      });
    });

    group('after solved ->', () {
      test('sets gameState to Solved', () async {
        dispatchActionAndUpdateState(SolveButtonPressedAction());

        // Takes a second to solve.  Gotta update the state too
        await Future.delayed(Duration(milliseconds: 1000));
        state = Redux.store.state;

        expect(state.gameState, GameState.Solved);
      });

      test('sets topText to "SOLVED" in green', () async {
        dispatchActionAndUpdateState(SolveButtonPressedAction());

        // Takes a second to solve.  Gotta update the state too
        await Future.delayed(Duration(milliseconds: 1000));
        state = Redux.store.state;

        expect(state.topTextState.text, MyStrings.topTextSolved);
        expect(state.topTextState.color, MyColors.green);
      });
    });
  });
}
