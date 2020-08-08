import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/store.dart';
import 'package:redux/redux.dart';


@immutable
class NumberAction {
  final NumberState numberState;

  NumberAction(this.numberState);
}

Future<void> numberPressedAction(Store<AppState> store) async {
  store.dispatch(NumberAction(NumberState(number: 9)));

  try {
    // final response = await http.get('https://jsonplaceholder.typicode.com/posts');
    // assert(response.statusCode == 200);
    // final jsonData = json.decode(response.body);
    store.dispatch(
      NumberAction(
        NumberState(
          number: 2,
        ),
      ),
    );
  } catch (error) {
    store.dispatch(NumberAction(NumberState(number: 7)));
  }
}
