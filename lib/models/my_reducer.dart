import 'package:sudoku_solver_2/models/my_action.dart';
import 'package:sudoku_solver_2/models/number_model.dart';

numberReducer(NumberState numberModel, NumberAction numberAction) {
  print('running numberReducer with $numberModel and $numberAction');
  final payload = numberAction.numberModel;
  return numberModel.copyWith(newNumber: payload.number);
}