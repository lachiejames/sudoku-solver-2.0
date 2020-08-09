import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/my_games.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/state/sudoku_state.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

void main() {
  group('SudokuState', () {
    SudokuState sudokuState;

    setUp(() {
      sudokuState = SudokuState(tileStateMap: MyWidgets.initTileStateMap());
    });

    test('toString() is correctly formatted', () {
      expect(sudokuState.toString(), MyGames.emptySudokuString);
    });

    test('initTileMap - initialised with 81 tiles', () {
      expect(sudokuState.tileStateMap.length, 81);
    });

    test('initTileMap - tiles are all valid', () {
      for (TileState tileState in sudokuState.tileStateMap.values.toList()) {
        expect(tileState, isNotNull);
        expect(1 <= tileState.row && tileState.row <= 9, true);
        expect(1 <= tileState.col && tileState.col <= 9, true);
        expect(tileState.value, isNull);
        expect(tileState.isTapped, false);
      }
    });
  });
}
