import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';

/// Contains all state reducers used by the NumberState List
final Reducer<List<NumberState>> numberStateListReducer =
    combineReducers<List<NumberState>>(<List<NumberState> Function(List<NumberState>, dynamic)>[
  TypedReducer<List<NumberState>, TileSelectedAction>(_makeNumberActive),
  TypedReducer<List<NumberState>, TileDeselectedAction>(_makeNumberInactive),
  TypedReducer<List<NumberState>, NumberPressedAction>(_makeNumberInactive2),
  TypedReducer<List<NumberState>, RestartAction>(_makeNumberInactive3),
  TypedReducer<List<NumberState>, ChangeScreenAction>(_clearNumberStateListReducer),
]);

List<NumberState> _makeNumberActive(List<NumberState> numberStateList, TileSelectedAction action) {
  final List<NumberState> newNumberStateList = <NumberState>[];
  for (final NumberState numberState in numberStateList) {
    newNumberStateList.add(numberState.copyWith(isActive: true));
  }

  return newNumberStateList;
}

List<NumberState> _makeNumberInactive(List<NumberState> numberStateList, TileDeselectedAction action) {
  final List<NumberState> newNumberStateList = <NumberState>[];

  for (final NumberState numberState in numberStateList) {
    newNumberStateList.add(numberState.copyWith(isActive: false));
  }

  return newNumberStateList;
}

List<NumberState> _makeNumberInactive2(List<NumberState> numberStateList, NumberPressedAction action) {
  final List<NumberState> newNumberStateList = <NumberState>[];
  for (final NumberState numberState in numberStateList) {
    newNumberStateList.add(numberState.copyWith(isActive: false));
  }

  return newNumberStateList;
}

List<NumberState> _makeNumberInactive3(List<NumberState> numberStateList, RestartAction action) {
  final List<NumberState> newNumberStateList = <NumberState>[];
  for (final NumberState numberState in numberStateList) {
    newNumberStateList.add(numberState.copyWith(isActive: false));
  }

  return newNumberStateList;
}

List<NumberState> _clearNumberStateListReducer(List<NumberState> numberStateList, ChangeScreenAction action) {
  // Shoudlnt clear if looking at help screen
  if (action.screenState != ScreenState.homeScreen) {
    return numberStateList;
  }

  final List<NumberState> newNumberStateList = <NumberState>[];
  for (final NumberState numberState in numberStateList) {
    newNumberStateList.add(numberState.copyWith(isActive: false));
  }

  return newNumberStateList;
}
