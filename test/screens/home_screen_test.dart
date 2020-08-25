import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/home_screen.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/widgets/home_screen/just_play_button_widget.dart';
import 'package:sudoku_solver_2/widgets/home_screen/solve_with_camera_button_widget.dart';
import 'package:sudoku_solver_2/widgets/home_screen/solve_with_touch_button_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/top_text_widget.dart';

void main() {
  group('HomeScreen -', () {
    HomeScreen homeScreen;

    Future<void> createHomeScreen(WidgetTester tester) async {
      homeScreen = HomeScreen();
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: MaterialApp(
            home: homeScreen,
          ),
        ),
      );
    }

    setUp(() async {
      Redux.init();
    });

    group('initial state -', () {
      testWidgets('should be defined', (WidgetTester tester) async {
        await createHomeScreen(tester);
        expect(homeScreen, isNotNull);
      });

      testWidgets('should contain the expected widgets', (WidgetTester tester) async {
        await createHomeScreen(tester);
        expect(find.byType(TopTextWidget), findsOneWidget);
        expect(find.byType(SolveWithCameraButtonWidget), findsOneWidget);
        expect(find.byType(SolveWithTouchButtonWidget), findsOneWidget);
        expect(find.byType(JustPlayButtonWidget), findsOneWidget);
      });

      testWidgets('top text should be "How would you like it to be solved?" ', (WidgetTester tester) async {
        await createHomeScreen(tester);
        expect(find.text('How would you like it to be solved?'), findsOneWidget);
      });

      testWidgets('top text should be "How would you like it to be solved?" ', (WidgetTester tester) async {
        await createHomeScreen(tester);
        expect(find.text('How would you like it to be solved?'), findsOneWidget);
      });
    });
  });
}
