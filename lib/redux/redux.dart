import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/redux/reducers/game_number_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/game_state_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/screen_state_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/number_state_list_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/top_text_state_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/tile_state_map_reducer.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
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
        numberStateList: MyWidgets.initNumberStateList(),
        topTextState: TopTextState.initialState(),

        gameNumber: (sharedPreferences != null) ? _getGameNumber() : 0,
        screenState: ScreenState.HomeScreen,
        gameState: GameState.Default,
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
    return state.copyWith(
      tileStateMap: tileStateMapReducer(state.tileStateMap, action),
      numberStateList: numberStateListReducer(state.numberStateList, action),
      topTextState: topTextStateReducer(state.topTextState, action),
      gameNumber: gameNumberReducer(state.gameNumber, action),
      screenState: screenStateReducer(state.screenState, action),
      gameState: gameStateReducer(state.gameState, action),
    );
  }
}
