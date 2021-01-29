import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/algorithm/solver.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import '../constants/test_constants.dart';

void main() {
  group('Solver ->', () {
    Sudoku sudoku;

    group('backtracking() algorithm ->', () {
      setUp(() async {
        setMockMethodsForUnitTests();
        await Redux.init();
        sudoku = Sudoku(tileStateMap: TileState.initTileStateMap())..applyExampleValues(games[0]);
      });

      test('results in a solved sudoku', () {
        startTime = DateTime.now().millisecondsSinceEpoch.toDouble();
        backtracking(sudoku);
        expect(sudoku.toString(), solvedGames[0]);
      });

      test('solveSudokuAsync returns a solved sudoku', () async {
        sudoku = solveSudoku(sudoku);
        expect(sudoku.toString(), solvedGames[0]);
      });
    });
  });
}
