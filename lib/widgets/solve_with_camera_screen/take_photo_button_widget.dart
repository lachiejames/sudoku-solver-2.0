import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

class TakePhotoButtonWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TakePhotoButtonWidgetState();
}

class TakePhotoButtonWidgetState extends State<TakePhotoButtonWidget> {
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
                MyStrings.takePhotoButtonText,
                style: MyStyles.buttonTextStyle,
              ),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}
