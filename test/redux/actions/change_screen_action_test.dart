import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';

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

  group('ChangeScreenAction ->', () {
    test('updates ScreenState to the provided Screen', () {
      expect(state.screenState, ScreenState.homeScreen);
      dispatchActionAndUpdateState(ChangeScreenAction(ScreenState.solveWithCameraScreen));
      expect(state.screenState, ScreenState.solveWithCameraScreen);
    });

    test('if updating to SolveWithCameraScreen, should set topText to "Align with camera" in white', () {
      dispatchActionAndUpdateState(ChangeScreenAction(ScreenState.solveWithCameraScreen));
      expect(state.topTextState.text, topTextTakingPhoto);
      expect(state.topTextState.color, white);
    });

    test('if updating to any other screen after, should set topText back to "Pick a tile" in white', () {
      dispatchActionAndUpdateState(ChangeScreenAction(ScreenState.solveWithCameraScreen));
      dispatchActionAndUpdateState(ChangeScreenAction(ScreenState.solveWithTouchScreen));
      expect(state.topTextState.text, topTextNoTileSelected);
      expect(state.topTextState.color, white);
    });
  });
}
