import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/algorithm/solver.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/my_games.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import '../constants/test_constants.dart';

void main() {
  group('Solver ->', () {
    Sudoku sudoku;

    group('backtracking() algorithm ->', () {
      setUp(() {
        sudoku = Sudoku(tileStateMap: MyWidgets.initTileStateMap());
        sudoku.applyExampleValues(MyGames.games[0]);
      });

      test('results in a solved sudoku', () {
        backtracking(sudoku);
        expect(sudoku.toString(), TestConstants.solvedGames[0]);
      });

      test('solveSudokuAsync returns a solved sudoku', () async {
        sudoku = await solveSudokuAsync(sudoku);
        expect(sudoku.toString(), TestConstants.solvedGames[0]);
      });
    });
  });
}
