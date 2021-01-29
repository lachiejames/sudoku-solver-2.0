import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

/// Contains text which provides tips for the user when the game changes state
class TopTextWidget extends StatelessWidget {
  const TopTextWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, TopTextState>(
        distinct: true,
        converter: (Store<AppState> store) => store.state.topTextState,
        builder: (BuildContext context, TopTextState topTextState) => Container(
          alignment: Alignment.center,
          padding: topTextMargins,
          child: Text(
            topTextState.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: topTextFontSize,
              color: topTextState.color,
            ),
            textDirection: TextDirection.ltr,
          ),
        ),
      );
}
