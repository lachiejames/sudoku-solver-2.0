import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

class NewGameButtonWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewGameButtonWidgetState();
}

class NewGameButtonWidgetState extends State<NewGameButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      distinct: true,
      converter: (store) => store.state.isSolved,
      builder: (context, isSolved) {
        // Should only be visible when solved
        return Opacity(
          opacity: (isSolved) ? 1.0 : 0.0,
          child: Container(
            alignment: Alignment.center,
            margin: MyStyles.buttonMargins,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: RaisedButton(
                shape: MyStyles.buttonShape,
                padding: MyStyles.buttonPadding,
                color: MyColors.blue,
                child: Text(
                  MyStrings.newGameButtonText,
                  style: MyStyles.buttonTextStyle,
                ),
                onPressed: () {
                  if (isSolved) {
                    Redux.store.dispatch(NewGameButtonPressedAction());
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}