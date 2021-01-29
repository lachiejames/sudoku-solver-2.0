import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/just_play_screen.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/just_play_screen/new_game_button_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/number_bar_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/sudoku_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/top_text_widget.dart';

import '../constants/test_constants.dart';

void main() {
  group('JustPlayScreen -', () {
    JustPlayScreen justPlayScreen;

    Future<void> createJustPlayScreen(WidgetTester tester) async {
      justPlayScreen = const JustPlayScreen();
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: MaterialApp(
            home: justPlayScreen,
          ),
        ),
      );
    }

    setUp(() async {
      setMockMethodsForUnitTests();
      await Redux.init();
      await Redux.store.dispatch(ChangeScreenAction(ScreenState.justPlayScreen));
    });

    group('initial state -', () {
      testWidgets('should be defined', (WidgetTester tester) async {
        await createJustPlayScreen(tester);
        expect(justPlayScreen, isNotNull);
      });

      testWidgets('should contain the expected widgets', (WidgetTester tester) async {
        await createJustPlayScreen(tester);
        expect(find.byType(TopTextWidget), findsOneWidget);
        expect(find.byType(NumberBarWidget), findsOneWidget);
        expect(find.byType(SudokuWidget), findsOneWidget);
        expect(find.byType(NewGameButtonWidget), findsOneWidget);
      });

      testWidgets('top text should be "Pick a tile", in white', (WidgetTester tester) async {
        await createJustPlayScreen(tester);
        expect(find.text('Pick a tile'), findsOneWidget);
      });
    });
  });
}
