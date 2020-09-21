import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/widgets/shared/number_widget.dart';

/// Contains numbers 1-9, which can be added to a tile
class NumberBarWidget extends StatefulWidget {
  NumberBarWidget({Key key}) : super(key: key);

  @override
  _NumberBarWidgetState createState() => _NumberBarWidgetState();
}

class _NumberBarWidgetState extends State<NumberBarWidget> {
  Widget makeNumber(int number) {
    return NumberWidget(number: number);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        textDirection: TextDirection.ltr,
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
