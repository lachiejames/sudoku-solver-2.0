import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/models/number_bar_model.dart';
import 'package:sudoku_solver_2/widgets/number_widget.dart';

class NumberBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NumberBarWidgetState();
}

class NumberBarWidgetState extends State<NumberBarWidget> {

  NumberBarModel numberBarModel = NumberBarModel();

  Widget makeNumber(int number) {
    return NumberWidget(numberModel: this.numberBarModel.numberModels[number-1]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          makeNumber(1),
          makeNumber(2),
          makeNumber(3),
          makeNumber(4),
          makeNumber(5),
          makeNumber(6),
          makeNumber(7),
          makeNumber(8),
          makeNumber(9),
        ],
      ),
    );
  }
}
