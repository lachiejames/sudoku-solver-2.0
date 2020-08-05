import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/models/top_text_model.dart';

class TopTextWidget extends StatefulWidget {
  @override
  _TopTextWidgetState createState() => _TopTextWidgetState();
}

class _TopTextWidgetState extends State<TopTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: MyStyles.topTextMargins,
      child: Consumer<TopTextModel>(
        builder: (context, topTextModel, child) {
          return Text(
            topTextModel.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MyValues.topTextFontSize,
              color: MyColors.black,
            ),
          );
        },
      ),
    );
  }
}
