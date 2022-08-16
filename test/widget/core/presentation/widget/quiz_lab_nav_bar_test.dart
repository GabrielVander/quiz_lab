import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiz_lab/core/presentation/widgets/quiz_lab_nav_bar.dart';
import 'package:quiz_lab/core/quiz_lab_application.dart';

void main() {
  group('Should render', () {
    testWidgets('Nav bar it self', (WidgetTester tester) async {
      await tester.pumpWidget(const QuizLabApplication());

      expect(find.byType(QuizLabNavBar), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('navBar')), findsOneWidget);
    });

    testWidgets('Assessments', (WidgetTester tester) async {
      await tester.pumpWidget(const QuizLabApplication());

      expect(find.byIcon(MdiIcons.schoolOutline), findsOneWidget);
      expect(find.text('Assessments'), findsOneWidget);
    });

    testWidgets('Questions', (WidgetTester tester) async {
      await tester.pumpWidget(const QuizLabApplication());

      expect(find.byIcon(MdiIcons.database), findsOneWidget);
      expect(find.text('Questions'), findsOneWidget);
    });

    testWidgets('Results', (WidgetTester tester) async {
      await tester.pumpWidget(const QuizLabApplication());

      expect(find.byIcon(MdiIcons.cardBulleted), findsOneWidget);
      expect(find.text('Results'), findsOneWidget);
    });
  });
}
