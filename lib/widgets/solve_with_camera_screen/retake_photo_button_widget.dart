import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';

class RetakePhotoButtonWidget extends StatefulWidget {
  RetakePhotoButtonWidget({Key key}) : super(key: key);

  @override
  _RetakePhotoButtonWidgetState createState() => _RetakePhotoButtonWidgetState();
}

class _RetakePhotoButtonWidgetState extends State<RetakePhotoButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: MyStyles.buttonMargins,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: RaisedButton(
          shape: MyStyles.buttonShape,
          padding: MyStyles.buttonPadding,
          color: (Redux.store.state.cameraState.cameraController == null) ? MyColors.grey : MyColors.blue,
          child: Text(
            MyStrings.retakePhotoButtonText,
            style: MyStyles.buttonTextStyle,
          ),
          onPressed: () async {
            Redux.store.dispatch(RetakePhotoAction());
          },
        ),
      ),
    );
  }
}
