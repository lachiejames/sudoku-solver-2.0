import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/state/number_state.dart';

class NumberWidget extends StatefulWidget {
  final NumberState numberState;
  NumberWidget({this.numberState});
  @override
  State<StatefulWidget> createState() => NumberWidgetState(numberState: this.numberState);
}

class NumberWidgetState extends State<NumberWidget> {
  final NumberState numberState;

  NumberWidgetState({@required this.numberState});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: MyValues.screenWidth / 11.5,
        width: MyValues.screenWidth / 11.5,
        margin: EdgeInsets.only(
          top: MyValues.screenWidth / 11.25,
          bottom: MyValues.screenWidth / 11.25,
          left: MyValues.screenWidth / 100,
          right: MyValues.screenWidth / 100,
        ),
        decoration: ShapeDecoration(
          color: (numberState.isTapped) ? MyColors.green : MyColors.white,
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
          ),
        ),
      ),
      onTap: () {
        print('tapped - $numberState');
      },
    );
  }
}
