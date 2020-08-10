@Skip('Solve games')

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/algorithm/solver.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/my_games.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';

import '../constants/test_constants.dart';

void main() {
  group('Solve games ->', () {
    Sudoku sudoku;

    setUp(() {
      sudoku = Sudoku(tileStateMap: MyWidgets.initTileStateMap());
    });

    test('game 0', () async {
      sudoku.applyExampleValues(MyGames.games[0]);
      sudoku = await solveSudokuAsync(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[0]);
    });

    test('game 1', () async {
      sudoku.applyExampleValues(MyGames.games[1]);
      sudoku = await solveSudokuAsync(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[1]);
    });

    test('game 2', () async {
      sudoku.applyExampleValues(MyGames.games[2]);
      sudoku = await solveSudokuAsync(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[2]);
    });

    test('game 3', () async {
      sudoku.applyExampleValues(MyGames.games[3]);
      sudoku = await solveSudokuAsync(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[3]);
    });

    test('game 4', () async {
      sudoku.applyExampleValues(MyGames.games[4]);
      sudoku = await solveSudokuAsync(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[4]);
    });

    test('game 5', () async {
      sudoku.applyExampleValues(MyGames.games[5]);
      sudoku = await solveSudokuAsync(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[5]);
    });

    test('game 6', () async {
      sudoku.applyExampleValues(MyGames.games[6]);
      sudoku = await solveSudokuAsync(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[6]);
    });

    test('game 7', () async {
      sudoku.applyExampleValues(MyGames.games[7]);
      sudoku = await solveSudokuAsync(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[7]);
    });

    test('game 8', () async {
      sudoku.applyExampleValues(MyGames.games[8]);
      sudoku = await solveSudokuAsync(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[8]);
    });

    test('game 9', () async {
      sudoku.applyExampleValues(MyGames.games[9]);
      sudoku = await solveSudokuAsync(sudoku);
      expect(sudoku.toString(), TestConstants.solvedGames[9]);
    });
  });
}
