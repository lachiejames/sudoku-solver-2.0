import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

class TileWidget extends StatefulWidget {
  final TileState tileState;
  TileWidget({@required this.tileState});
  @override
  State<StatefulWidget> createState() => TileWidgetState(tileState: this.tileState);
}

class TileWidgetState extends State<TileWidget> {
  final TileState tileState;
  TileWidgetState({this.tileState});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: (this.tileState.row == 3 || this.tileState.row == 6) ? 3 : 0, color: Colors.black),
            right: BorderSide(width: (this.tileState.col == 3 || this.tileState.col == 6) ? 3 : 0, color: Colors.black),
          ),
          color: (tileState.isTapped) ? MyColors.green : MyColors.white,
        ),
        child: Center(
          child: Text(
            (tileState.value == null) ? '' : '${tileState.value}',
            style: TextStyle(
              fontSize: MyValues.tileFontSize,
              fontFamily: MyStyles.fontStyleNumber,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      onTap: () {},
    );
  }
}
