import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';

class RestartButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: my_styles.buttonMargins,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: RaisedButton(
          shape: my_styles.buttonShape,
          padding: my_styles.buttonPadding,
          color: my_colors.blue,
          child: Text(
            my_strings.restartButtonText,
            style: my_styles.buttonTextStyle,
          ),
          onPressed: () async {
            Redux.store.dispatch(RestartAction());
            await my_values.firebaseAnalytics.logEvent(name: 'button_restart');
          },
        ),
      ),
    );
  }
}
