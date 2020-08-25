import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/solve_with_camera_screen.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

void main() {
  group('SolveWithCameraScreen -', () {
    SolveWithCameraScreen solveWithCameraScreen;

    Future<void> createJustPlayHelpScreen(WidgetTester tester) async {
      solveWithCameraScreen = SolveWithCameraScreen();
      print(Redux.store.state.gameState);
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: MaterialApp(
            home: solveWithCameraScreen,
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
        expect(solveWithCameraScreen, isNotNull);
      });
    });
  });
}
