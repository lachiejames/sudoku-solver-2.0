import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/my_games.dart' as my_games;
import 'package:sudoku_solver_2/redux/actions.dart';

/// Contains all state reducers used by GameNumber
final Reducer<int> gameNumberReducer = combineReducers<int>([
  TypedReducer<int, NewGameButtonPressedAction>(_newGameReducer),
]);

int _newGameReducer(int gameNumber, NewGameButtonPressedAction action) {
  int newGameNumber = (gameNumber + 1) % my_games.games.length;
  return newGameNumber;
}
