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
import 'package:sudoku_solver_2/state/screen_state.dart';

/// Shown when the SolveWithCameraScreen is loaded
class StopProcessingPhotoButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        if (gameState != GameState.processingPhoto) {
          return Container();
        }
        return Container(
          alignment: Alignment.center,
          margin: my_styles.buttonMargins,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RaisedButton(
                shape: my_styles.buttonShape,
                padding: my_styles.buttonPadding,
                color: my_colors.red,
                child: Text(
                  my_strings.topTextStopConstructingSudoku,
                  style: my_styles.buttonTextStyle,
                ),
                onPressed: () async {
                  await my_values.takePhotoButtonPressedTrace.incrementMetric('stop-constructing-button-pressed', 1);
                  Redux.store.dispatch(StopProcessingPhotoAction());
                  Redux.store.dispatch(ChangeScreenAction(ScreenState.solveWithCameraScreen));
                  await my_values.firebaseAnalytics.logEvent(name: 'button_take_photo');
                }),
          ),
        );
      },
    );
  }
}
