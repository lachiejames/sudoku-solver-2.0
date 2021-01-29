import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';

/// Contains all state reducers used by GameNumber
final Reducer<int> gameNumberReducer = combineReducers<int>(<int Function(int, dynamic)>[
  TypedReducer<int, NewGameButtonPressedAction>(_newGameReducer),
]);

int _newGameReducer(int gameNumber, NewGameButtonPressedAction action) {
  final int newGameNumber = (gameNumber + 1) % games.length;
  return newGameNumber;
}
