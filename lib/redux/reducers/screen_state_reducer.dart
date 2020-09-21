import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';

import 'package:redux/redux.dart';

/// Contains all state reducers used by the ScreenState
final Reducer<ScreenState> screenStateReducer = combineReducers<ScreenState>([
  TypedReducer<ScreenState, ChangeScreenAction>(_changeScreenReducer),
]);

ScreenState _changeScreenReducer(ScreenState screenState, ChangeScreenAction action) {
  return action.screenState;
}
