import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/model.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(items: itemReducer(state.items, action));
}

List<Item> itemReducer(List<Item> state, action) {
  if (action is AddItemAction) {
    return []
      ..addAll(state)
      ..add(Item(
        id: action.id,
        body: action.item,
      ));
  }

  if (action is RemoveItemAction) {
    return List.unmodifiable(List.from(state)..remove(action.item));
  }

  if (action is RemoveItemsAction) {
    return List.unmodifiable([]);
  }
  return state;
}
