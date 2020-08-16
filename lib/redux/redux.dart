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
    return combineReducers<AppState>([
      TypedReducer<AppState, TileSelectedAction>(tileSelectedReducer),
      TypedReducer<AppState, TileDeselectedAction>(tileDeselectedReducer),
      TypedReducer<AppState, RemoveValueFromTileAction>(removeValueFromTileReducer),
      TypedReducer<AppState, NumberPressedAction>(numberPressedReducer),
      TypedReducer<AppState, SolveButtonPressedAction>(solveButtonPressedReducer),
      TypedReducer<AppState, StartSolvingSudokuAction>(startSolvingSudokuReducer),
      TypedReducer<AppState, SudokuSolvedAction>(sudokuSolvedReducer),
      TypedReducer<AppState, RestartAction>(restartReducer),
      TypedReducer<AppState, LoadPlayScreenWithSudokuAction>(loadPlayScreenWithSudokuReducer),
      TypedReducer<AppState, NewGameButtonPressedAction>(newGameButtonPressedReducer),
      TypedReducer<AppState, GameSolvedAction>(gameSolvedReducer),
      TypedReducer<AppState, ChangeScreenAction>(changeScreenReducer),
    ]).call(state, action);
  }
}
