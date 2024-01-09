import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/features/application_information/ui/bloc/version_display/version_display_cubit.dart';
import 'package:quiz_lab/features/application_information/ui/widgets/version_display.dart';

void main() {
  late VersionDisplayCubit cubit;

  setUp(() {
    cubit = _MockVersionDisplayCubit();
  });

  group('golden tests', () {
    testWidgets('loading', (WidgetTester tester) async {
      when(() => cubit.displayApplicationVersion()).thenAnswer((_) async {});
      when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => cubit.state).thenReturn(const VersionDisplayState(version: '7s#!&&', isLoading: true));

      await tester.pumpFrames(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VersionDisplay(cubit: cubit),
            ),
          ),
        ),
        const Duration(milliseconds: 100),
      );

      await expectLater(
        find.byType(VersionDisplay),
        matchesGoldenFile('golden/version_display/loading.png'),
      );

      verify(() => cubit.displayApplicationVersion());
    });

    testWidgets('error', (WidgetTester tester) async {
      when(() => cubit.displayApplicationVersion()).thenAnswer((_) async {});
      when(() => cubit.stream).thenAnswer(
        (_) => Stream.value(const VersionDisplayState(version: r'$LX3', isLoading: false, errorCode: 'h#Cm!Yu')),
      );
      when(() => cubit.state).thenReturn(const VersionDisplayState(version: '7s#!&&', isLoading: true));

      await tester.pumpFrames(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VersionDisplay(cubit: cubit),
            ),
          ),
        ),
        const Duration(milliseconds: 500),
      );

      await expectLater(
        find.byType(VersionDisplay),
        matchesGoldenFile('golden/version_display/error.png'),
      );
    });

    testWidgets('version text', (WidgetTester tester) async {
      when(() => cubit.displayApplicationVersion()).thenAnswer((_) async {});
      when(() => cubit.stream).thenAnswer(
        (_) => Stream.value(const VersionDisplayState(version: '5u^BV3', isLoading: false)),
      );
      when(() => cubit.state).thenReturn(const VersionDisplayState(version: '7s#!&&', isLoading: true));

      await tester.pumpFrames(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VersionDisplay(cubit: cubit),
            ),
          ),
        ),
        const Duration(milliseconds: 100),
      );

      await expectLater(
        find.byType(VersionDisplay),
        matchesGoldenFile('golden/version_display/version_text.png'),
      );
    });
  });
}

class _MockVersionDisplayCubit extends Mock implements VersionDisplayCubit {}
