import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';

class SolveItButtonWidget extends StatefulWidget {
  SolveItButtonWidget({Key key}) : super(key: key);

  @override
  _SolveItButtonWidgetState createState() => _SolveItButtonWidgetState();
}

class _SolveItButtonWidgetState extends State<SolveItButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        left: 32,
        right: 32,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: RaisedButton(
          shape: MyStyles.buttonShape,
          padding: MyStyles.buttonPadding,
          color: (Redux.store.state.cameraState.cameraController == null) ? MyColors.grey : MyColors.blue,
          child: Text(
            MyStrings.solveItButtonText,
            style: MyStyles.buttonTextStyle,
          ),
          onPressed: () async {
            Redux.store.dispatch(StartSolvingSudokuAction());
          },
        ),
      ),
    );
  }
}
