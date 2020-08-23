import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';

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

  static Widget makeAppBar(String appBarText) {
    return AppBar(
      iconTheme: IconThemeData(color: MyColors.white),
      title: Text(
        appBarText,
        textAlign: TextAlign.left,
        style: MyStyles.appBarTextStyle,
        textDirection: TextDirection.ltr,
      ),
    );
  }

  static Widget makeHowToText(String text) {
    return Container(
      margin: MyStyles.topTextMargins,
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: MyStyles.howToTextStyle,
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
