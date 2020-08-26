import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/just_play_help_screen.dart';
import 'package:sudoku_solver_2/state/app_state.dart';

void main() {
  group('JustPlayHelpScreen -', () {
    JustPlayHelpScreen justPlayHelpScreen;

    Future<void> createJustPlayHelpScreen(WidgetTester tester) async {
      justPlayHelpScreen = JustPlayHelpScreen();
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: MaterialApp(
            home: justPlayHelpScreen,
          ),
        ),
      );
    }

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await Redux.init();
    });

    group('initial state -', () {
      testWidgets('should be defined', (WidgetTester tester) async {
        await createJustPlayHelpScreen(tester);
        expect(justPlayHelpScreen, isNotNull);
      });
    });
  });
}
