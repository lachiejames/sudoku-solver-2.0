import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

class SolveMySudokuButtonWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SolveMySudokuButtonWidgetState();
}

class SolveMySudokuButtonWidgetState extends State<SolveMySudokuButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      distinct: true,
      converter: (store) => store.state.isSolving,
      builder: (context, isSolving) {
        return Container(
          alignment: Alignment.center,
          margin: MyStyles.buttonMargins,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RaisedButton(
              shape: MyStyles.buttonShape,
              padding: MyStyles.buttonPadding,
              color: (isSolving) ? MyColors.grey : MyColors.blue,
              child: Text(
                'SOLVE MY SUDOKU',
                style: MyStyles.buttonTextStyle,
              ),
              // Should be disabled while solving
              onPressed: (isSolving)
                  ? null
                  : () {
                      Redux.store.dispatch(SolveButtonPressedAction());
                    },
            ),
          ),
        );
      },
    );
  }
}
