import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';

class NumberWidget extends StatefulWidget {
  final int number;
  NumberWidget({this.number});
  @override
  State<StatefulWidget> createState() => NumberWidgetState(number: this.number);
}

class NumberWidgetState extends State<NumberWidget> {
  final int number;

  NumberWidgetState({@required this.number});

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
              color: (numberState.isActive) ? MyColors.green : MyColors.white,
              shape: CircleBorder(),
            ),
            child: Center(
              child: Text(
                '${numberState.number}',
                style: TextStyle(
                  fontSize: MyValues.numberFontSize,
                  fontFamily: MyStyles.fontStyleNumber,
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
