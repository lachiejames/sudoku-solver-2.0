import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/top_text_state.dart';

/// Contains text which provides tips for the user when the game changes state
class TopTextWidget extends StatefulWidget {
  TopTextWidget({Key key}) : super(key: key);

  @override
  _TopTextWidgetState createState() => _TopTextWidgetState();
}

class _TopTextWidgetState extends State<TopTextWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TopTextState>(
      distinct: true,
      converter: (store) => store.state.topTextState,
      builder: (context, topTextState) {
        return Container(
          alignment: Alignment.center,
          padding: MyStyles.topTextMargins,
          child: Text(
            topTextState.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MyValues.topTextFontSize,
              color: topTextState.color,
            ),
            textDirection: TextDirection.ltr,
          ),
        );
      },
    );
  }
}
