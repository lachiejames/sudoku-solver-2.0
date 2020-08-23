import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';

class MyWidgets {
  static Widget getEmptyWidget() {
    return Container();
  }

  static Widget makeProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: MyColors.green,
      ),
    );
  }
}
