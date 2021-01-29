import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/solve_with_touch_help_screen.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

import '../constants/test_constants.dart';

void main() {
  group('SolveWithTouchHelpScreen -', () {
    SolveWithTouchHelpScreen solveWithTouchHelpScreen;

    Future<void> createJustPlayHelpScreen(WidgetTester tester) async {
      solveWithTouchHelpScreen = const SolveWithTouchHelpScreen();
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: MaterialApp(
            home: solveWithTouchHelpScreen,
          ),
        ),
      );
    }

    setUp(() async {
      setMockMethodsForUnitTests();
      await Redux.init();
    });

    group('initial state -', () {
      testWidgets('should be defined', (WidgetTester tester) async {
        await createJustPlayHelpScreen(tester);
        expect(solveWithTouchHelpScreen, isNotNull);
      });
    });
  });
}
