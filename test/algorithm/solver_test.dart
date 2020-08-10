import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/algorithm/solver.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/constants/my_games.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import '../constants/test_constants.dart';

void main() {
  group('Solver ->', () {
    Sudoku currentStateHere;

    group('backtracking() algorithm ->', () {
      setUp(() {
        currentStateHere = Sudoku(tileStateMap: MyWidgets.initTileStateMap());
        currentStateHere.applyExampleValues(MyGames.games[0]);
        cspState = currentStateHere;
      });

      test('results in a solved sudoku', () {
        backtracking(currentStateHere);
        expect(currentStateHere.toString(), TestConstants.solvedGames[0]);
      });
    });

    group('solve games ->', () {
      setUp(() {
        currentStateHere = Sudoku(tileStateMap: MyWidgets.initTileStateMap());
      });

      void solveGame(exampleValues) {
        currentStateHere.applyExampleValues(exampleValues);
        solveSudoku(currentStateHere);
      }

      test('solve game 0', () {
        solveGame(MyGames.games[0]);
        expect(currentStateHere.toString(), TestConstants.solvedGames[0]);
      });

      test('solve game 1', () {
        solveGame(MyGames.games[1]);
        expect(currentStateHere.toString(), TestConstants.solvedGames[1]);
      });

      test('solve game 2', () {
        solveGame(MyGames.games[2]);
        expect(currentStateHere.toString(), TestConstants.solvedGames[2]);
      });

      test('solve game 3', () {
        solveGame(MyGames.games[3]);
        expect(currentStateHere.toString(), TestConstants.solvedGames[3]);
      });

      test('solve game 4', () {
        solveGame(MyGames.games[4]);
        expect(currentStateHere.toString(), TestConstants.solvedGames[4]);
      });

      test('solve game 5', () {
        solveGame(MyGames.games[5]);
        expect(currentStateHere.toString(), TestConstants.solvedGames[5]);
      });

      test('solve game 6', () {
        solveGame(MyGames.games[6]);
        expect(currentStateHere.toString(), TestConstants.solvedGames[6]);
      });

      test('solve game 7', () {
        solveGame(MyGames.games[7]);
        expect(currentStateHere.toString(), TestConstants.solvedGames[7]);
      });

      test('solve game 8', () {
        solveGame(MyGames.games[8]);
        expect(currentStateHere.toString(), TestConstants.solvedGames[8]);
      });

      test('solve game 9', () {
        solveGame(MyGames.games[9]);
        expect(currentStateHere.toString(), TestConstants.solvedGames[9]);
      });
    });
  });
}
