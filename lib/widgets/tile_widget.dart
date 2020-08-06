import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
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
    return ChangeNotifierProvider<TileModel>(
      create: (_) => TileModel(
        row: this.tileModel.row,
        col: this.tileModel.col,
        value:this.tileModel.value,
      ),
      child: GestureDetector(
        child: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: (this.tileModel.row == 3 || this.tileModel.row == 6) ? 3 : 0, color: Colors.black),
              right: BorderSide(width: (this.tileModel.row == 3 || this.tileModel.row == 6) ? 3 : 0, color: Colors.black),
            ),
          ),
          child: Center(
            child: Consumer<TileModel>(
              builder: (context, model, child) {
                return Text(
                  (model.value == null) ? '' : '${model.value}',
                  style: TextStyle(
                    fontSize: MyValues.tileFontSize,
                    fontFamily: MyStyles.fontStyleNumber,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            ),
          ),
        ),
        onTap: () {
          print('tile pressed');
        },
      ),
    );
  }
}
