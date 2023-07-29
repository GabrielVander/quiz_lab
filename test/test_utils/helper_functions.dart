import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> safeTapByKey(WidgetTester tester, Key key) async {
  final target = find.byKey(key);

  expect(target, findsOneWidget);
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
}
