import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/solve_with_touch_screen.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

void main() {
  Redux.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StoreProvider<AppState>(
        store: Redux.store,
        child: SolveWithTouchScreen(),
      ),
    );
  }
}
