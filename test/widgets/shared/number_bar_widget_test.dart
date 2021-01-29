import 'dart:async';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/widgets/shared/number_bar_widget.dart';

import '../../constants/test_constants.dart';

void main() {
  group('NumberBarWidget -', () {
    NumberBarWidget numberBarWidget;

    Future<void> createNumberBarWidget(WidgetTester tester) async {
      numberBarWidget = const NumberBarWidget();
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: numberBarWidget,
        ),
      );
    }

    setUp(() async {
      setMockMethodsForUnitTests();
      await Redux.init();
    });

    group('initial state -', () {
      testWidgets('should be defined', (WidgetTester tester) async {
        await createNumberBarWidget(tester);

        expect(numberBarWidget, isNotNull);
      });

      testWidgets('should contain numbers 1 - 9', (WidgetTester tester) async {
        await createNumberBarWidget(tester);

        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
        expect(find.text('5'), findsOneWidget);
        expect(find.text('6'), findsOneWidget);
        expect(find.text('7'), findsOneWidget);
        expect(find.text('8'), findsOneWidget);
        expect(find.text('9'), findsOneWidget);
      });
    });
  });
}
