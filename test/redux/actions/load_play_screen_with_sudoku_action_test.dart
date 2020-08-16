import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';

void main() {
  AppState state;
  TileKey tileKey = TileKey(row: 1, col: 1);

  void dispatchActionAndUpdateState(dynamic action) {
    Redux.store.dispatch(action);
    state = Redux.store.state;
  }

  setUp(() {
    Redux.init();
    state = Redux.store.state;
  });

  group('LoadPlayScreenWithSudokuAction ->', () {
    test('Fills tileStateMap with values', () {
      dispatchActionAndUpdateState(LoadPlayScreenWithSudokuAction(0));
      expect(state.tileStateMap[TileKey(row: 1, col: 1)].value, 5);
      expect(state.tileStateMap[TileKey(row: 1, col: 3)].value, null);
    });

    test('Fills tileStateMap with originalTiles', () {
      dispatchActionAndUpdateState(LoadPlayScreenWithSudokuAction(0));
      expect(state.tileStateMap[TileKey(row: 1, col: 1)].isOriginalTile, true);
      expect(state.tileStateMap[TileKey(row: 1, col: 3)].isOriginalTile, false);
    });
  });
}
