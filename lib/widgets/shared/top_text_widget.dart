import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
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
          padding: my_styles.topTextMargins,
          child: Text(
            topTextState.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: my_values.topTextFontSize,
              color: topTextState.color,
            ),
            textDirection: TextDirection.ltr,
          ),
        );
      },
    );
  }
}
