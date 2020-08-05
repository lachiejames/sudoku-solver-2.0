import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';

class MyWidgets {
  static Widget getEmptyWidget() {
    return Text('');
  }

  static Widget makeButtonText(String text) {
    return Text(
      text,
      style: MyStyles.buttonTextStyle,
    );
  }

  static Widget makeText(String text) {
    return Text(
      text,
      style: MyStyles.appBarTextStyle,
    );
  }

  static Widget makeAppBar(String appBarText) {
    return AppBar(
      iconTheme: IconThemeData(color: MyColors.white),
      title: Text(
        appBarText,
        textAlign: TextAlign.left,
        style: MyStyles.appBarTextStyle,
      ),
    );
  }

  static Widget makeTopText(String text, Color color) {
    return Container(
      alignment: Alignment.center,
      padding: MyStyles.topTextMargins,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: MyValues.topTextFontSize,
          color: color,
        ),
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
      ),
    );
  }
}
