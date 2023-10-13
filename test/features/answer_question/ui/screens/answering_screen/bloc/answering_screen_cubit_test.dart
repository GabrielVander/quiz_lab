import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/answer_question/domain/usecases/get_question_with_id.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/bloc/question_answering_cubit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';

void main() {
  late QuizLabLogger logger;
  late GetQuestionWithId getSingleQuestionUseCaseMock;

  late QuestionAnsweringCubit cubit;

  setUp(() {
    logger = _MockQuizLabLogger();
    getSingleQuestionUseCaseMock = _GetSingleQuestionUseCaseMock();

    cubit = QuestionAnsweringCubit(
      logger: logger,
      getSingleQuestionUseCase: getSingleQuestionUseCaseMock,
    );
  });

  tearDown(() {
    cubit.close();
    mocktail.resetMocktailState();
  });

  test('initial state', () {
    expect(cubit.state, isA<AnsweringScreenInitial>());
  });

  group('loadQuestion', () {
    for (final questionId in ['bhv3PXKt', 'y4a']) {
      group('when given $questionId as question id', () {
        test('should emit AnsweringScreenError if GetSingleQuestionUseCase fails', () async {
          when(() => getSingleQuestionUseCaseMock.execute(any())).thenAnswer((_) async => const Err(unit));

          unawaited(
            expectLater(
              cubit.stream,
              emitsInOrder(
                [
                  const AnsweringScreenLoading(),
                  const AnsweringScreenError(message: 'Unable to load question'),
                  emitsDone,
                ],
              ),
            ),
          );

          await cubit.loadQuestion(questionId);
          await cubit.close();

          verify(() => getSingleQuestionUseCaseMock.execute(questionId)).called(1);
        });

        for (final question in [
          const Question(
            id: QuestionId('ueH'),
            description: 'FfpV5',
            difficulty: QuestionDifficulty.easy,
            answerOptions: [],
            shortDescription: 'KD71k',
            categories: [],
          ),
          const Question(
            id: QuestionId('J4u'),
            description: 'LEW8',
            difficulty: QuestionDifficulty.easy,
            answerOptions: [
              AnswerOption(description: 'ZJt', isCorrect: true),
              AnswerOption(description: '2Zi1xU', isCorrect: false),
            ],
            shortDescription: 'E8X',
            categories: [],
          ),
        ]) {
          test('should emit question updates for $question', () async {
            when(() => getSingleQuestionUseCaseMock.execute(any())).thenAnswer((_) async => Ok(question));

            unawaited(
              expectLater(
                cubit.stream,
                emitsInAnyOrder(
                  [
                    const AnsweringScreenLoading(),
                    AnsweringScreenTitleUpdated(value: question.shortDescription),
                    AnsweringScreenDescriptionUpdated(value: question.description),
                    AnsweringScreenDifficultyUpdated(value: question.difficulty.name),
                    isA<AnsweringScreenAnswersUpdated>(),
                    emitsDone,
                  ],
                ),
              ),
            );

            await cubit.loadQuestion(questionId);
            await cubit.close();

            verify(() => getSingleQuestionUseCaseMock.execute(questionId)).called(1);
          });
        }
      });
    }
  });

  group('onOptionSelected', () {
    for (final optionId in ['A0UbM', 'si68hkfk']) {
      test('should emit expected for $optionId as option id', () async {
        unawaited(
          expectLater(
            cubit.stream,
            emitsInOrder(
              [
                AnsweringScreenAnswerOptionWasSelected(id: optionId),
                const AnsweringScreenAnswerButtonEnabled(),
                emitsDone,
              ],
            ),
          ),
        );

        await cubit.onOptionSelected(optionId);
        await cubit.close();
      });
    }
  });

  // group('onAnswer', () {
  //   test('should emit expected', () async {
  //     unawaited(
  //       expectLater(
  //         cubit.stream,
  //         emitsInOrder(
  //           [
  //             const AnsweringScreenHideAnswerButton(),
  //             AnsweringScreenShowResult(
  //               correctAnswerId: "firstCorrectAnswer",
  //               selectedAnswerId: "firstSelectedAnswer",
  //             ),
  //             emitsDone,
  //           ],
  //         ),
  //       ),
  //     );
  //
  //     await cubit.onAnswer();
  //     await cubit.close();
  //   });
  // });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _GetSingleQuestionUseCaseMock extends mocktail.Mock implements GetQuestionWithId {}
