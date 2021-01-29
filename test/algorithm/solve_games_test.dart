// @Skip('Solve games')

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/algorithm/solver.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

import '../constants/test_constants.dart';

void main() {
  group('Solve games ->', () {
    Sudoku sudoku;

    setUp(() {
      setMockMethodsForUnitTests();
      sudoku = Sudoku(tileStateMap: TileState.initTileStateMap());
    });

    test('game 0', () async {
      sudoku.applyExampleValues(games[0]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), solvedGames[0]);
    });

    test('game 1', () async {
      sudoku.applyExampleValues(games[1]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), solvedGames[1]);
    });

    test('game 2', () async {
      sudoku.applyExampleValues(games[2]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), solvedGames[2]);
    });

    test('game 3', () async {
      sudoku.applyExampleValues(games[3]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), solvedGames[3]);
    });

    test('game 4', () async {
      sudoku.applyExampleValues(games[4]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), solvedGames[4]);
    });

    test('game 5', () async {
      sudoku.applyExampleValues(games[5]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), solvedGames[5]);
    });

    test('game 6', () async {
      sudoku.applyExampleValues(games[6]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), solvedGames[6]);
    });

    test('game 7', () async {
      sudoku.applyExampleValues(games[7]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), solvedGames[7]);
    });

    test('game 8', () async {
      sudoku.applyExampleValues(games[8]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), solvedGames[8]);
    });

    test('game 9', () async {
      sudoku.applyExampleValues(games[9]);
      sudoku = solveSudoku(sudoku);
      expect(sudoku.toString(), solvedGames[9]);
    });
  });
}
