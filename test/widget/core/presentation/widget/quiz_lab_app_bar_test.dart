// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_app_bar.dart';
import 'package:quiz_lab/core/quiz_lab_application.dart';

void main() {
  group('Should render', () {
    testWidgets('App bar it self', (WidgetTester tester) async {
      await tester.pumpWidget(const QuizLabApplication());

      expect(find.byType(QuizLabAppBar), findsOneWidget);
    });

    testWidgets('Icon', (WidgetTester tester) async {
      await tester.pumpWidget(const QuizLabApplication());

      expect(find.byKey(const ValueKey('appBarIcon')), findsOneWidget);
    });

    testWidgets('Title', (WidgetTester tester) async {
      await tester.pumpWidget(const QuizLabApplication());

      expect(find.byKey(const ValueKey('appBarTitle')), findsOneWidget);
      expect(find.text('Quiz Lab'), findsOneWidget);
    });

    testWidgets('Settings button', (WidgetTester tester) async {
      await tester.pumpWidget(const QuizLabApplication());

      expect(
        find.byKey(const ValueKey('appBarSettingsButton')),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });
}
