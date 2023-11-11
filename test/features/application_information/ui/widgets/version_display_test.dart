import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/application_information/domain/usecases/retrieve_application_version.dart';
import 'package:quiz_lab/features/application_information/ui/widgets/version_display.dart';

void main() {
  late QuizLabLogger logger;
  late RetrieveApplicationVersion retrieveApplicationVersion;

  setUp(() {
    logger = _MockQuizLabLogger();
    retrieveApplicationVersion = _MockRetrieveApplicationVersion();
  });

  group('golden tests', () {
    testWidgets('loading', (WidgetTester tester) async {
      when(() => retrieveApplicationVersion()).thenAnswer((_) async => Completer<Result<String, String>>().future);

      await tester.pumpFrames(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VersionDisplay(logger: logger, retrieveApplicationVersion: retrieveApplicationVersion),
            ),
          ),
        ),
        const Duration(seconds: 1),
      );

      await expectLater(
        find.byType(VersionDisplay),
        matchesGoldenFile('golden/version_display/loading.png'),
      );
    });

    testWidgets('error', (WidgetTester tester) async {
      when(() => retrieveApplicationVersion()).thenAnswer((_) async => const Err('h#Cm!Yu'));

      await tester.pumpFrames(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VersionDisplay(logger: logger, retrieveApplicationVersion: retrieveApplicationVersion),
            ),
          ),
        ),
        const Duration(seconds: 1),
      );

      await expectLater(
        find.byType(VersionDisplay),
        matchesGoldenFile('golden/version_display/error.png'),
      );
    });

    for(final version in ['o@CgjD0', 'Nx0Eeq8']) {
      testWidgets('version display: $version', (WidgetTester tester) async {
        when(() => retrieveApplicationVersion()).thenAnswer((_) async => Ok(version));

        await tester.pumpFrames(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: VersionDisplay(logger: logger, retrieveApplicationVersion: retrieveApplicationVersion),
              ),
            ),
          ),
          const Duration(seconds: 1),
        );

        await expectLater(
          find.byType(VersionDisplay),
          matchesGoldenFile('golden/version_display/display_$version.png'),
        );
      });
    }
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockRetrieveApplicationVersion extends Mock implements RetrieveApplicationVersion {}
