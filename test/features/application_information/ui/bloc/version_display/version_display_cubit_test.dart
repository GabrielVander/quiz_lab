import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/application_information/domain/usecases/retrieve_application_version.dart';
import 'package:quiz_lab/features/application_information/ui/bloc/version_display/version_display_cubit.dart';

void main() {
  late QuizLabLogger logger;
  late RetrieveApplicationVersion retrieveApplicationVersionUseCase;
  late VersionDisplayCubit cubit;

  setUp(() {
    logger = _MockQuizLabLogger();
    retrieveApplicationVersionUseCase = _MockRetrieveApplicationVersion();

    cubit = VersionDisplayCubit(logger, retrieveApplicationVersionUseCase);
  });

  test('initial state', () {
    expect(
      cubit.state,
      const VersionDisplayState(version: '-', isLoading: true),
    );
  });

  group('displayApplicationVersion', () {
    for (final message in ['C5HDM7a', '0&#48']) {
      test('should emit loading true then message error when RetrieveApplicationVersion returns Err', () async {
        when(() => retrieveApplicationVersionUseCase()).thenAnswer((_) async => Err(message));

        final expected = [
          const VersionDisplayState(version: '-', isLoading: true),
          VersionDisplayState(
            version: '-',
            isLoading: false,
            errorCode: VersionDisplayCubitErrorCodes.unableToRetrieveApplicationVersion.name,
          ),
        ];

        unawaited(
          expectLater(
            cubit.stream,
            emitsInOrder(expected),
          ),
        );

        await cubit.displayApplicationVersion();
        await cubit.close();
      });
    }

    for (final version in ['*NBN^', '*qI']) {
      test('should emit loading true then expected version when RetrieveApplicationVersion returns Ok', () async {
        when(() => retrieveApplicationVersionUseCase()).thenAnswer((_) async => Ok(version));

        final expected = [
          const VersionDisplayState(version: '-', isLoading: true),
          VersionDisplayState(version: 'v$version', isLoading: false),
        ];

        unawaited(
          expectLater(
            cubit.stream,
            emitsInOrder(expected),
          ),
        );

        await cubit.displayApplicationVersion();
        await cubit.close();
      });
    }
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockRetrieveApplicationVersion extends Mock implements RetrieveApplicationVersion {}
