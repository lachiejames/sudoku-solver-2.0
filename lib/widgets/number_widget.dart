import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';

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
          color: MyColors.white,
          shape: CircleBorder(),
        ),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              fontSize: MyValues.numberFontSize,
              fontFamily: MyStyles.fontStyleNumber,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      onTap: () {
        print(number);
      },
    );
  }
}
