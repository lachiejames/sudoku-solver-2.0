import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/widgets/just_play_screen/new_game_button_widget.dart';

void main() {
  group('NewGameButtonWidget -', () {
    NewGameButtonWidget newGameButtonWidget;

    Future<void> createNewGameButtonWidget(WidgetTester tester) async {
      newGameButtonWidget = NewGameButtonWidget();
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: newGameButtonWidget,
        ),
      );
    }

    Color newGameButtonWidgetColor(WidgetTester tester) {
      return ((tester.firstWidget(find.byType(RaisedButton)) as RaisedButton)).color;
    }

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await Redux.init();
    });

    group('initial state -', () {
      testWidgets('should be defined', (WidgetTester tester) async {
        await createNewGameButtonWidget(tester);

        expect(newGameButtonWidget, isNotNull);
      });

      testWidgets('should be invisible', (WidgetTester tester) async {
        await createNewGameButtonWidget(tester);
        expect(find.text('NEW GAME'), findsNothing);
      });
    });

    group('after game is solved -', () {
      setUp(() {
        Redux.store.dispatch(GameSolvedAction());
      });

      testWidgets('should be blue', (WidgetTester tester) async {
        await createNewGameButtonWidget(tester);
        expect(newGameButtonWidgetColor(tester), my_colors.blue);
      });

      testWidgets('tapping should increment the gameNumber', (WidgetTester tester) async {
        await createNewGameButtonWidget(tester);

        int oldGameNumber = Redux.store.state.gameNumber;
        await tester.tap(find.byWidget(newGameButtonWidget));
        int newGameNumber = Redux.store.state.gameNumber;

        expect(oldGameNumber, 0);
        expect(newGameNumber, 1);
      });
    });
  });
}
