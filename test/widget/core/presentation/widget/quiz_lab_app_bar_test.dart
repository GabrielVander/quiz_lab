import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/quiz_lab_application.dart';
import 'package:quiz_lab/core/widgets/quiz_lab_app_bar.dart';

void main() {
  group('Should render', () {
    testWidgets('App bar it self', (WidgetTester tester) async {
      await tester.pumpWidget(QuizLabApplication());

      expect(find.byType(QuizLabAppBar), findsOneWidget);
    });

    testWidgets('Icon', (WidgetTester tester) async {
      await tester.pumpWidget(QuizLabApplication());

      expect(find.byKey(const ValueKey('appBarIcon')), findsOneWidget);
    });

    testWidgets('Title', (WidgetTester tester) async {
      await tester.pumpWidget(QuizLabApplication());

      expect(find.byKey(const ValueKey('appBarTitle')), findsOneWidget);
      expect(find.text('Quiz Lab'), findsOneWidget);
    });

    testWidgets('Settings button', (WidgetTester tester) async {
      await tester.pumpWidget(QuizLabApplication());

      expect(
        find.byKey(const ValueKey('appBarSettingsButton')),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });
}
