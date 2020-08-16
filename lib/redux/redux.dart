import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/reducers/shared/change_screen_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/just_play_screen/load_play_screen_with_sudoku_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/just_play_screen/new_game_button_pressed_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/shared/number_pressed_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/shared/remove_value_from_tile_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/shared/restart_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/shared/solve_button_pressed_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/shared/start_solving_sudoku_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/shared/sudoku_solved_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/shared/tile_deselected_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/shared/tile_selected_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/just_play_screen/game_solved_reducer.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';

class Redux {
  static Store<AppState> _store;
  static SharedPreferences sharedPreferences;

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
        topTextState: TopTextState.initialState(),
        isSolving: false,
        isSolved: false,
        gameNumber: (sharedPreferences != null) ? _getGameNumber() : 0,
        screenState: ScreenState.HomeScreen,
      ),
    );
  }

  static int _getGameNumber() {
    assert(sharedPreferences != null);
    int gameNumber = sharedPreferences.getInt('sudoku_solver_game_number');

    if (gameNumber == null) {
      gameNumber = 0;
      sharedPreferences.setInt('sudoku_solver_game_number', gameNumber);
    }

    return gameNumber;
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
    } else if (action is StartSolvingSudokuAction) {
      return startSolvingSudokuReducer(state, action);
    } else if (action is SudokuSolvedAction) {
      return sudokuSolvedReducer(state, action);
    } else if (action is RestartAction) {
      return restartReducer(state, action);
    } else if (action is LoadPlayScreenWithSudokuAction) {
      return loadPlayScreenWithSudokuReducer(state, action);
    } else if (action is NewGameButtonPressedAction) {
      return newGameButtonPressedReducer(state, action);
    } else if (action is GameSolvedAction) {
      return gameSolvedReducer(state, action);
    } else if (action is ChangeScreenAction) {
      return changeScreenReducer(state, action);
    }

    return state;
  }
}
