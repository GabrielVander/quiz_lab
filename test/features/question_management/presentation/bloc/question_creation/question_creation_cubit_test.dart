import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/question_creation_cubit.dart';

void main() {
  late QuizLabLogger logger;
  late CreateQuestionUseCase createQuestionUseCase;

  late QuestionCreationCubit cubit;

  setUp(() {
    logger = _MockQuizLabLogger();
    createQuestionUseCase = _MockCreateQuestionUseCase();

    cubit = QuestionCreationCubit(
      logger: logger,
      createQuestionUseCase: createQuestionUseCase,
    );
  });

  tearDown(resetMocktailState);

  group('toggleIsQuestionPublic', () {
    test('should log initial message', () async {
      cubit.toggleIsQuestionPublic();

      verify(() => logger.debug('Toggling public status...')).called(1);
    });

    test('should emit [QuestionCreationPublicStatusUpdated(true)]', () async {
      unawaited(
        expectLater(
          cubit.stream,
          emitsInOrder(
            [
              const QuestionCreationPublicStatusUpdated(isPublic: true),
              const QuestionCreationPublicStatusUpdated(isPublic: false),
              const QuestionCreationPublicStatusUpdated(isPublic: true),
              emitsDone
            ],
          ),
        ),
      );

      cubit
        ..toggleIsQuestionPublic()
        ..toggleIsQuestionPublic()
        ..toggleIsQuestionPublic();

      await cubit.close();
    });
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockCreateQuestionUseCase extends Mock
    implements CreateQuestionUseCase {}
