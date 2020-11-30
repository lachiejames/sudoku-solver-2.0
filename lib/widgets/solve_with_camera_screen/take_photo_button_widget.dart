import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;

/// Shown when the SolveWithCameraScreen is loaded
class TakePhotoButtonWidget extends StatefulWidget {
  TakePhotoButtonWidget({Key key}) : super(key: key);

  @override
  _TakePhotoButtonWidgetState createState() => _TakePhotoButtonWidgetState();
}

class _TakePhotoButtonWidgetState extends State<TakePhotoButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        return (gameState == GameState.takingPhoto || gameState == GameState.processingPhoto)
            ? Container(
                key: this._createPropertyKey(gameState),
                alignment: Alignment.center,
                margin: my_styles.buttonMargins,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: RaisedButton(
                    shape: my_styles.buttonShape,
                    padding: my_styles.buttonPadding,
                    color: _determineColor(gameState),
                    child: Text(
                      _determineText(gameState),
                      style: my_styles.buttonTextStyle,
                    ),
                    onPressed: () => _determineAction(gameState, context),
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Key _createPropertyKey(GameState gameState) {
    String key = 'text:${this._determineText(gameState)}';
    key += ' - color:${this._determineColorString(gameState)}';
    return Key(key);
  }

  String _determineColorString(GameState gameState) {
    switch (gameState) {
      case GameState.processingPhoto:
        return 'red';
      default:
        return 'blue';
    }
  }

  Color _determineColor(GameState gameState) {
    switch (gameState) {
      case GameState.processingPhoto:
        return my_colors.red;
      default:
        return my_colors.blue;
    }
  }

  String _determineText(GameState gameState) {
    switch (gameState) {
      case GameState.processingPhoto:
        return my_strings.topTextStopConstructingSudoku;
      default:
        return my_strings.takePhotoButtonText;
    }
  }

  void _determineAction(GameState gameState, BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double verticalPadding = (screenSize.height - 296) / 2;
    double horizontalPadding = my_values.pad;

    switch (gameState) {
      case GameState.processingPhoto:
        Redux.store.dispatch(StopProcessingPhotoAction());
        Redux.store.dispatch(ChangeScreenAction(ScreenState.solveWithCameraScreen));
        break;
      default:
        Redux.store.dispatch(
          SetCameraStateProperties(
            screenSize: MediaQuery.of(context).size,
            cameraWidgetBounds: Rect.fromLTRB(
              horizontalPadding,
              verticalPadding,
              screenSize.width - horizontalPadding,
              screenSize.height - verticalPadding,
            ),
          ),
        );
        Redux.store.dispatch(TakePhotoAction());
    }
  }
}
