import 'package:sudoku_solver_2/state/my_action.dart';
import 'package:sudoku_solver_2/state/number_state.dart';

numberReducer(NumberState numberState, NumberAction numberAction) {
  print('running numberReducer with $numberState and $numberAction');
  final payload = numberAction.numberState;
  return numberState.copyWith(newNumber: payload.number);
}