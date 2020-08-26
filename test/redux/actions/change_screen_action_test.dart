import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
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
      expect(state.screenState, ScreenState.HomeScreen);
      dispatchActionAndUpdateState(ChangeScreenAction(ScreenState.SolveWithCameraScreen));
      expect(state.screenState, ScreenState.SolveWithCameraScreen);
    });

    test('if updating to SolveWithCameraScreen, should set topText to "Align with camera" in white', () {
      dispatchActionAndUpdateState(ChangeScreenAction(ScreenState.SolveWithCameraScreen));
      expect(state.topTextState.text, MyStrings.topTextTakingPhoto);
      expect(state.topTextState.color, MyColors.white);
    });

    test('if updating to any other screen after, should set topText back to "Pick a tile" in white', () {
      dispatchActionAndUpdateState(ChangeScreenAction(ScreenState.SolveWithCameraScreen));
      dispatchActionAndUpdateState(ChangeScreenAction(ScreenState.SolveWithTouchScreen));
      expect(state.topTextState.text, MyStrings.topTextNoTileSelected);
      expect(state.topTextState.color, MyColors.white);
    });
  });
}
