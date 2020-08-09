import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/number_bar_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';
import 'package:sudoku_solver_2/redux/reducers.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is TilePressedAction) {
    return state.copyWith(tileStateMap: tilePressedReducer(state.tileStateMap, action));
  }

  return state;
}

@immutable
class AppState {
  final HashMap<TileKey, TileState> tileStateMap;
  final NumberBarState numberBarState;
  final TopTextState topTextState;

  AppState({
    @required this.tileStateMap,
    @required this.numberBarState,
    @required this.topTextState,
  });

  AppState copyWith({
    HashMap<TileKey, TileState> tileStateMap,
    NumberBarState numberBarState,
    TopTextState topTextState,
  }) {
    return AppState(
      tileStateMap: tileStateMap ?? this.tileStateMap,
      numberBarState: numberBarState ?? this.numberBarState,
      topTextState: topTextState ?? this.topTextState,
    );
  }
}

class Redux {
  static Store<AppState> _store;

  static Store<AppState> get store {
    if (_store == null) {
      throw Exception("store is not initialized");
    } else {
      return _store;
    }
  }

  static Future<void> init() async {
    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(
        tileStateMap: MyWidgets.initTileStateMap(),
        numberBarState: NumberBarState(),
        topTextState: TopTextState(),
      ),
    );
  }
}
