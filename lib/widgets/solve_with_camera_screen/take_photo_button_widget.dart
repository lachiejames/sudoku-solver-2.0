import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';

class TakePhotoButtonWidget extends StatefulWidget {
  TakePhotoButtonWidget({Key key}) : super(key: key);

  @override
  _TakePhotoButtonWidgetState createState() => _TakePhotoButtonWidgetState();
}

class _TakePhotoButtonWidgetState extends State<TakePhotoButtonWidget> {
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
            MyStrings.takePhotoButtonText,
            style: MyStyles.buttonTextStyle,
          ),
          onPressed: () async {
            Redux.store.dispatch(TakePhotoAction());
          },
        ),
      ),
    );
  }
}
