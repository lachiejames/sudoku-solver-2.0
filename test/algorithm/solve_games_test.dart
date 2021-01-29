// @Skip('Solve games')

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/algorithm/solver.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/state/tile_state.dart';

import '../constants/test_constants.dart';

void main() {
  group('Solve games ->', () {
    Sudoku sudoku;

    setUp(() {
      TestConstants.setMockMethodsForUnitTests();
      sudoku = Sudoku(tileStateMap: TileState.initTileStateMap());
    });

    test('game 0', () async {
      sudoku.applyExampleValues(constants.games[0]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[0]);
    });

    test('game 1', () async {
      sudoku.applyExampleValues(constants.games[1]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[1]);
    });

    test('game 2', () async {
      sudoku.applyExampleValues(constants.games[2]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[2]);
    });

    test('game 3', () async {
      sudoku.applyExampleValues(constants.games[3]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[3]);
    });

    test('game 4', () async {
      sudoku.applyExampleValues(constants.games[4]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[4]);
    });

    test('game 5', () async {
      sudoku.applyExampleValues(constants.games[5]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[5]);
    });

    test('game 6', () async {
      sudoku.applyExampleValues(constants.games[6]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[6]);
    });

    test('game 7', () async {
      sudoku.applyExampleValues(constants.games[7]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[7]);
    });

    test('game 8', () async {
      sudoku.applyExampleValues(constants.games[8]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[8]);
    });

    test('game 9', () async {
      sudoku.applyExampleValues(constants.games[9]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[9]);
    });
  });
}
