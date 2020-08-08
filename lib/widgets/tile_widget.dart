import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/models/game_model.dart';
import 'package:sudoku_solver_2/models/my_action.dart';
import 'package:sudoku_solver_2/models/store.dart';
import 'package:sudoku_solver_2/models/tile_model.dart';

class TileWidget extends StatefulWidget {
  final TileModel tileModel;
  TileWidget({@required this.tileModel});
  @override
  State<StatefulWidget> createState() => TileWidgetState(tileModel: this.tileModel);
}

class TileWidgetState extends State<TileWidget> {
  final TileModel tileModel;
  TileWidgetState({this.tileModel});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, int>(
      distinct: true,
      converter: (store) => store.state.numberState.number,
      builder: (context, isLoading) {
        return GestureDetector(
          child: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: (this.tileModel.row == 3 || this.tileModel.row == 6) ? 3 : 0, color: Colors.black),
                right: BorderSide(width: (this.tileModel.col == 3 || this.tileModel.col == 6) ? 3 : 0, color: Colors.black),
              ),
              color: (tileModel.isTapped) ? MyColors.green : MyColors.white,
            ),
            child: Center(
              child: Text(
                (tileModel.value == null) ? '' : '${tileModel.value}',
                style: TextStyle(
                  fontSize: MyValues.tileFontSize,
                  fontFamily: MyStyles.fontStyleNumber,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          onTap: () {
            print('dispatching numberPressedAction from $tileModel');
            Redux.store.dispatch(numberPressedAction);
          },
        );
      },
    );
  }
}
