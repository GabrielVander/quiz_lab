import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/core/themes/light_theme.dart';
import 'package:quiz_lab/core/widgets/quiz_lab_nav_bar.dart';

void main() {
  group('Should render', () {
    testWidgets('Nav bar it self', (WidgetTester tester) async {
      await tester.pumpWidget(_buildWidgetUnderTest());

      expect(find.byType(QuizLabNavBar), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('navBar')), findsOneWidget);
    });

    testWidgets('Assessments', (WidgetTester tester) async {
      await tester.pumpWidget(_buildWidgetUnderTest());

      expect(find.text('Assessments'), findsOneWidget);
    });

    testWidgets('Questions', (WidgetTester tester) async {
      await tester.pumpWidget(_buildWidgetUnderTest());

      expect(find.text('Questions'), findsOneWidget);
    });

    testWidgets('Results', (WidgetTester tester) async {
      await tester.pumpWidget(_buildWidgetUnderTest());

      expect(find.text('Results'), findsOneWidget);
    });
  });
}

Widget _buildWidgetUnderTest() {
  return MaterialApp(
    theme: lightTheme,
    home: const Scaffold(
      bottomNavigationBar: QuizLabNavBar(
        key: ValueKey<String>('navBar'),
      ),
    ),
  );
}
