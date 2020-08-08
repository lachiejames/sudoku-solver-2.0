import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:sudoku_solver_2/models/my_action.dart';
import 'package:sudoku_solver_2/models/my_reducer.dart';
import 'package:sudoku_solver_2/models/number_model.dart';

AppState appReducer(AppState appState, dynamic action) {
  print('appReducer with appState and action');
  if (action is NumberAction) {
    print('action is a number action');
    final nextNumberState = numberReducer(appState.numberState, action);
    return appState.copyWith(numberState: nextNumberState);
  }

  return appState;
}

@immutable
class AppState {
  final NumberState numberState;

  AppState({
    @required this.numberState,
  });

  AppState copyWith({
    NumberState numberState,
  }) {
    return AppState(
      numberState: numberState ?? this.numberState,
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
    final initialGameState = NumberState(number: 3);

    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(numberState: initialGameState),
    );
  }
}