import 'dart:collection';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

AppState solveButtonPressedReducer(AppState appState, SolveButtonPressedAction action) {
  final HashMap<TileKey, TileState> newTileStateMap = HashMap.from(appState.tileStateMap);

  return appState.copyWith(
    tileStateMap: newTileStateMap,
  );
}


// SudokuState cspState;
// bool backtracking(SudokuState sudokuState) {
//   if (sudokuState.isComplete() || timeElapsed > MyValues.maxSolveTime) {
//     return true;
//   }

//   TileState tile = sudokuState.getNextUnassignedTile();

//   for (int value in sudokuState.getPossibleValuesAtTile(tile)) {
//     cspState.addValueToTile(value, tile);

//     if (cspState.allConstraintsSatisfied()) {
//       if (backtracking(cspState)) {
//         return true;
//       }
//     }
//     cspState.addValueToTile(null, tile);
//   }

//   return false;
// }

// SudokuState solveSudoku(SudokuState cs) {
//   startTime = DateTime.now().millisecondsSinceEpoch;
//   cspState = cs;
//   backtracking(cs);
//   return cs;
// }

// solveWithCompute(SudokuState cs) async {
//   SudokuState solvedSudoku = await compute(solveSudoku, cs);
//   return solvedSudoku;
// }