import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/reducers/number_pressed_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/remove_value_from_tile_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/solve_button_pressed_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/tile_deselected_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/tile_selected_reducer.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

class Redux {
  static Store<AppState> _store;

  static Store<AppState> get store {
    if (_store == null) {
      throw Exception("store is not initialized");
    } else {
      return _store;
    }
  }

  static void init() {
    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(
        tileStateMap: MyWidgets.initTileStateMap(),
        hasSelectedTile: false,
        numberStateList: MyWidgets.initNumberStateList(),
        topTextState: TopTextState(),
      ),
    );
  }

  static AppState appReducer(AppState state, dynamic action) {
    if (action is TileSelectedAction) {
      return tileSelectedReducer(state, action);
    } else if (action is TileDeselectedAction) {
      return tileDeselectedReducer(state, action);
    } else if (action is RemoveValueFromTileAction) {
      return removeValueFromTileReducer(state, action);
    } else if (action is NumberPressedAction) {
      return numberPressedReducer(state, action);
    } else if (action is SolveButtonPressedAction) {
      return solveButtonPressedReducer(state, action);
    }

    return state;
  }
}