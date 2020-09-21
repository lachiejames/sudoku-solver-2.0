import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';

/// Contains a number from 1-9 for the user to select
class NumberWidget extends StatefulWidget {
  final int number;
  NumberWidget({this.number, Key key}) : super(key: key);

  @override
  _NumberWidgetState createState() => _NumberWidgetState(number: this.number);
}

class _NumberWidgetState extends State<NumberWidget> {
  final int number;

  _NumberWidgetState({@required this.number});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NumberState>(
      distinct: true,
      converter: (store) => store.state.numberStateList[this.number - 1],
      builder: (context, numberState) {
        assert(numberState.number != null);
        return GestureDetector(
          child: Container(
            height: 36,
            width: 36,
            margin: EdgeInsets.only(
              top: 36,
              bottom: 36,
              left: 4,
              right: 4,
            ),
            decoration: ShapeDecoration(
              color: (numberState.isActive) ? my_colors.green : my_colors.white,
              shape: CircleBorder(),
            ),
            child: Center(
              child: Text(
                '${numberState.number}',
                style: TextStyle(
                  fontSize: my_values.numberFontSize,
                  fontFamily: my_styles.fontStyleNumber,
                  fontWeight: FontWeight.w400,
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
          onTap: () {
            if (numberState.isActive) {
              Redux.store.dispatch(NumberPressedAction(numberState));
            }
          },
        );
      },
    );
  }
}
