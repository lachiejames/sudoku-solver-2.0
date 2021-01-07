import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/redux/reducers/camera_state_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/game_number_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/game_state_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/screen_state_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/number_state_list_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/top_text_state_reducer.dart';
import 'package:sudoku_solver_2/redux/reducers/tile_state_map_reducer.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;

/// Core component for state management
class Redux {
  static Store<AppState> _store;
  static SharedPreferences sharedPreferences;

  static Store<AppState> get store {
    if (_store == null) {
      throw Exception('store is not initialized');
    } else {
      return _store;
    }
  }

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();

    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(
        tileStateMap: TileState.initTileStateMap(),
        numberStateList: NumberState.initNumberStateList(),
        topTextState: TopTextState.initialState(),
        gameNumber: (sharedPreferences != null) ? await _getGameNumber() : 0,
        screenState: ScreenState.homeScreen,
        gameState: GameState.normal,
        cameraState: CameraState.initCameraState(),
      ),
    );
  }

  static Future<int> _getGameNumber() async {
    assert(sharedPreferences != null);
    int gameNumber = sharedPreferences.getInt(constants.gameNumberSharedPrefsKey);

    if (gameNumber == null) {
      gameNumber = 0;
      await sharedPreferences.setInt(constants.gameNumberSharedPrefsKey, gameNumber);
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
      cameraState: cameraStateReducer(state.cameraState, action),
    );
  }
}
