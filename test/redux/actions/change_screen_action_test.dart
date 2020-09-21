import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';

void main() {
  AppState state;

  void dispatchActionAndUpdateState(dynamic action) {
    Redux.store.dispatch(action);
    state = Redux.store.state;
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Redux.init();
    state = Redux.store.state;
  });

  group('ChangeScreenAction ->', () {
    test('updates ScreenState to the provided Screen', () {
      expect(state.screenState, ScreenState.homeScreen);
      dispatchActionAndUpdateState(ChangeScreenAction(ScreenState.solveWithCameraScreen));
      expect(state.screenState, ScreenState.solveWithCameraScreen);
    });

    test('if updating to SolveWithCameraScreen, should set topText to "Align with camera" in white',
        () {
      dispatchActionAndUpdateState(ChangeScreenAction(ScreenState.solveWithCameraScreen));
      expect(state.topTextState.text, my_strings.topTextTakingPhoto);
      expect(state.topTextState.color, my_colors.white);
    });

    test('if updating to any other screen after, should set topText back to "Pick a tile" in white',
        () {
      dispatchActionAndUpdateState(ChangeScreenAction(ScreenState.solveWithCameraScreen));
      dispatchActionAndUpdateState(ChangeScreenAction(ScreenState.solveWithTouchScreen));
      expect(state.topTextState.text, my_strings.topTextNoTileSelected);
      expect(state.topTextState.color, my_colors.white);
    });
  });
}
