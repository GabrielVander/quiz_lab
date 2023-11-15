import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_lab/common/ui/screens/configurations/configurations_screen.dart';

void main() {
  group('golden tests', () {
    testWidgets('bottom widget only', (WidgetTester tester) async {
      await tester.pumpFrames(
        const MaterialApp(
          home: ConfigurationsScreen(
            options: [],
            bottomWidget: Text('M8F*Sny'),
          ),
        ),
        const Duration(milliseconds: 100),
      );

      await expectLater(
        find.byType(ConfigurationsScreen),
        matchesGoldenFile('golden/bottom_widget_only.png'),
      );
    });

    group('tiles only', () {
      for (final amount in [1, 2, 3]) {
        testWidgets('with $amount tiles', (WidgetTester tester) async {
          await tester.pumpFrames(
            MaterialApp(
              home: ConfigurationsScreen(
                options: List<ListTile>.generate(
                  amount,
                  (_) => const ListTile(title: Text('M8F*Sny')),
                ),
              ),
            ),
            const Duration(milliseconds: 100),
          );

          await expectLater(
            find.byType(ConfigurationsScreen),
            matchesGoldenFile('golden/tiles_only_with_${amount}_tiles.png'),
          );
        });
      }
    });

    group('tiles and bottom widget', () {
      for (final amount in [1, 2, 3]) {
        testWidgets('with $amount tiles', (WidgetTester tester) async {
          await tester.pumpFrames(
            MaterialApp(
              home: ConfigurationsScreen(
                options: List<ListTile>.generate(
                  amount,
                  (_) => const ListTile(title: Text('9nHVr8^')),
                ),
                bottomWidget: const Text('i0LJ'),
              ),
            ),
            const Duration(milliseconds: 100),
          );

          await expectLater(
            find.byType(ConfigurationsScreen),
            matchesGoldenFile('golden/tiles_and_bottom_widget_with_${amount}_tiles.png'),
          );
        });
      }
    });
  });
}
