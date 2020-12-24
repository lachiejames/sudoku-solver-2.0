import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Shown when the user has taken a photo, but wants to take another
class RetakePhotoButtonWidget extends StatelessWidget {
  final List<GameState> _gameStatesToBeActiveFor = [
    GameState.photoProcessed,
    GameState.invalidTilesPresent,
    GameState.noSolution,
    GameState.processingPhotoError,
    GameState.solvingSudokuError,
  ];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        if (!_gameStatesToBeActiveFor.contains(gameState)) {
          return Container();
        }

        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(0),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RaisedButton(
              shape: my_styles.buttonShape,
              padding: my_styles.buttonPadding,
              color: my_colors.blue,
              child: Text(
                my_strings.retakePhotoButtonText,
                style: my_styles.buttonTextStyle,
              ),
              onPressed: () async {
                Redux.store.dispatch(RetakePhotoAction());
                await my_values.firebaseAnalytics.logEvent(name: 'button_retake_photo');
              },
            ),
          ),
        );
      },
    );
  }
}
