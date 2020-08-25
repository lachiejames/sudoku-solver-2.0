import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/solve_with_camera_help_screen.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

void main() {
  group('SolveWithCameraHelpScreen -', () {
    SolveWithCameraHelpScreen solveWithCameraHelpScreen;

    Future<void> createJustPlayHelpScreen(WidgetTester tester) async {
      solveWithCameraHelpScreen = SolveWithCameraHelpScreen();
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: MaterialApp(
            home: solveWithCameraHelpScreen,
          ),
        ),
      );
    }

    setUp(() async {
      Redux.init();
    });

    group('initial state -', () {
      testWidgets('should be defined', (WidgetTester tester) async {
        await createJustPlayHelpScreen(tester);
        expect(solveWithCameraHelpScreen, isNotNull);
      });
    });
  });
}
