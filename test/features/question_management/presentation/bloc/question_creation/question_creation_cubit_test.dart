import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/domain/entities/draft_question.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/check_if_user_can_create_public_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/question_creation/question_creation_cubit.dart';

void main() {
  late QuizLabLogger logger;
  late CreateQuestionUseCase createQuestionUseCase;
  late CheckIfUserCanCreatePublicQuestionsUseCase checkIfUserCanCreatePublicQuestionsUseCase;

  late QuestionCreationCubit cubit;

  setUp(() {
    logger = _MockQuizLabLogger();
    createQuestionUseCase = _MockCreateQuestionUseCase();
    checkIfUserCanCreatePublicQuestionsUseCase = _MockCheckIfUserCanCreatePublicQuestionsUseCase();

    cubit = QuestionCreationCubit(
      logger: logger,
      createQuestionUseCase: createQuestionUseCase,
      checkIfUserCanCreatePublicQuestionsUseCase: checkIfUserCanCreatePublicQuestionsUseCase,
    );
  });

  tearDown(resetMocktailState);

  group('load', () {
    group('when checking if should enable is public toggle', () {
      test('should log initial message', () {
        when(() => checkIfUserCanCreatePublicQuestionsUseCase()).thenAnswer((_) async => const Err('LW6jE'));

        cubit.load();

        verify(() => logger.info('Checking if user can create public questions...')).called(1);
      });

      for (final error in ['6jMd7qbb', '57zx4W']) {
        test('should log and emit [QuestionCreationHidePublicToggle] when use case fails with $error', () async {
          when(() => checkIfUserCanCreatePublicQuestionsUseCase()).thenAnswer((_) async => Err(error));

          unawaited(
            expectLater(
              cubit.stream,
              emitsInOrder(
                [
                  emitsThrough(const QuestionCreationHidePublicToggle()),
                  emitsThrough(emitsDone),
                ],
              ),
            ),
          );

          await cubit.load();
          await cubit.close();

          verify(() => logger.error(error)).called(1);
        });
      }

      for (final testCase in [
        (false, const QuestionCreationHidePublicToggle()),
        (true, const QuestionCreationShowPublicToggle())
      ]) {
        final canCreatePublicQuestions = testCase.$1;
        final expectedState = testCase.$2;

        test('should emit [$expectedState] when use case succeeds with $canCreatePublicQuestions', () async {
          when(() => checkIfUserCanCreatePublicQuestionsUseCase())
              .thenAnswer((_) async => Ok(canCreatePublicQuestions));

          unawaited(
            expectLater(
              cubit.stream,
              emitsInOrder(
                [
                  emitsThrough(expectedState),
                  emitsThrough(emitsDone),
                ],
              ),
            ),
          );

          await cubit.load();
          await cubit.close();
        });
      }
    });
  });

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

  group('onCreateQuestion', () {
    setUp(() {
      registerFallbackValue(
        const DraftQuestion(
          title: 'title',
          description: 'description',
          difficulty: 'difficulty',
          options: [],
          categories: [],
        ),
      );
    });

    test('should log initial message', () async {
      when(() => createQuestionUseCase(any())).thenAnswer((_) async => const Err('ne7Wl'));

      await cubit.onCreateQuestion();

      verify(() => logger.info('Creating question...')).called(1);
    });

    group('should save questio with correct isPublic value', () {
      for (final testCase in [(0, false), (1, true), (0, false), (3, true), (99, true), (100, false)]) {
        final amountOfToggles = testCase.$1;
        final expectedValue = testCase.$2;

        test(
          'when isPublic is toggled $amountOfToggles times should call create question use case with is public status = $expectedValue',
          () async {
            when(() => createQuestionUseCase(any())).thenAnswer((_) async => const Err('occRS'));

            cubit
              ..onTitleChanged('8FwM')
              ..onDescriptionChanged('iVQ')
              ..onDifficultyChanged('easy')
              ..onOptionChanged(
                cubit.defaultViewModel.options[0].id,
                'wpbY7Zq4',
              )
              ..onOptionChanged(cubit.defaultViewModel.options[1].id, '91r6QS')
              ..toggleOptionIsCorrect(cubit.defaultViewModel.options[0].id);

            for (var i = 0; i < amountOfToggles; ++i) {
              cubit.toggleIsQuestionPublic();
            }

            await cubit.onCreateQuestion();
            await cubit.close();

            verify(
              () => createQuestionUseCase(
                any(
                  that: isA<DraftQuestion>().having((e) => e.isPublic, 'isPublic', expectedValue),
                ),
              ),
            ).called(1);
          },
        );
      }
    });
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockCreateQuestionUseCase extends Mock implements CreateQuestionUseCase {}

class _MockCheckIfUserCanCreatePublicQuestionsUseCase extends Mock
    implements CheckIfUserCanCreatePublicQuestionsUseCase {}
