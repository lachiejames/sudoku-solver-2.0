import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/algorithm/solver.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/my_games.dart' as my_games;
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import '../constants/test_constants.dart';

void main() {
  group('Solver ->', () {
    Sudoku sudoku;

    group('backtracking() algorithm ->', () {
      setUp(() async {
        SharedPreferences.setMockInitialValues({});
        await Redux.init();
        sudoku = Sudoku(tileStateMap: TileState.initTileStateMap());
        sudoku.applyExampleValues(my_games.games[0]);
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
