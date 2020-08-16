import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/state/number_state.dart';

final Reducer<List<NumberState>> numberStateListReducer = combineReducers<List<NumberState>>([
  TypedReducer<List<NumberState>, TileSelectedAction>(_makeNumberActive),
  TypedReducer<List<NumberState>, TileDeselectedAction>(_makeNumberInactive),
  TypedReducer<List<NumberState>, NumberPressedAction>(_makeNumberInactive2),
  TypedReducer<List<NumberState>, RestartAction>(_makeNumberInactive3),
]);

List<NumberState> _makeNumberActive(List<NumberState> numberStateList, TileSelectedAction action) {
  List<NumberState> newNumberStateList = List<NumberState>();
  numberStateList.forEach((numberState) {
    newNumberStateList.add(numberState.copyWith(isActive: true));
  });

  return newNumberStateList;
}

List<NumberState> _makeNumberInactive(List<NumberState> numberStateList, TileDeselectedAction action) {
  List<NumberState> newNumberStateList = List<NumberState>();
  numberStateList.forEach((numberState) {
    newNumberStateList.add(numberState.copyWith(isActive: false));
  });

  return newNumberStateList;
}

List<NumberState> _makeNumberInactive2(List<NumberState> numberStateList, NumberPressedAction action) {
  List<NumberState> newNumberStateList = List<NumberState>();
  numberStateList.forEach((numberState) {
    newNumberStateList.add(numberState.copyWith(isActive: false));
  });

  return newNumberStateList;
}

List<NumberState> _makeNumberInactive3(List<NumberState> numberStateList, RestartAction action) {
  List<NumberState> newNumberStateList = List<NumberState>();
  numberStateList.forEach((numberState) {
    newNumberStateList.add(numberState.copyWith(isActive: false));
  });

  return newNumberStateList;
}
