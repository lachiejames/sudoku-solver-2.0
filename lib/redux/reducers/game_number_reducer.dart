import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/my_games.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';

final Reducer<int> gameNumberReducer = combineReducers<int>([
  TypedReducer<int, NewGameButtonPressedAction>(_newGameReducer),
]);

int _newGameReducer(int gameNumber, NewGameButtonPressedAction action) {
  int newGameNumber = (gameNumber + 1) % MyGames.games.length;
  Redux.sharedPreferences.setInt('sudoku_solver_game_number', newGameNumber);
  return newGameNumber;
}