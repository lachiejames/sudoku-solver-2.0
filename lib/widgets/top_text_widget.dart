import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/models/game_model.dart';

class TopTextWidget extends StatefulWidget {
  @override
  _TopTextWidgetState createState() => _TopTextWidgetState();
}

class _TopTextWidgetState extends State<TopTextWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GameModel.getInstance(),
      child: Consumer<GameModel>(
        builder: (context, gameModel, child) {
          // print('toptextWidget rebuilding');

          return Container(
            alignment: Alignment.center,
            padding: MyStyles.topTextMargins,
            child: Text(
              MyStrings.topTextPickATile,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MyValues.topTextFontSize,
                color: MyColors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
