import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/models/game_model.dart';
import 'package:sudoku_solver_2/models/number_model.dart';

class NumberWidget extends StatefulWidget {
  final NumberModel numberModel;
  NumberWidget({this.numberModel});
  @override
  State<StatefulWidget> createState() => NumberWidgetState(numberModel: this.numberModel);
}

class NumberWidgetState extends State<NumberWidget> {
  final NumberModel numberModel;

  NumberWidgetState({@required this.numberModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GameModel.getInstance(),
      child: Consumer<GameModel>(
        builder: (context, gameModel, child) {
          print('numberWidget rebuilding');

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
                color: (numberModel.isTapped) ? MyColors.green : MyColors.white,
                shape: CircleBorder(),
              ),
              child: Center(
                child: Text(
                  '${numberModel.number}',
                  style: TextStyle(
                    fontSize: MyValues.numberFontSize,
                    fontFamily: MyStyles.fontStyleNumber,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            onTap: () {
              gameModel.sentNumberPressedEvent(this.numberModel.number);
            },
          );
        },
      ),
    );
  }
}
