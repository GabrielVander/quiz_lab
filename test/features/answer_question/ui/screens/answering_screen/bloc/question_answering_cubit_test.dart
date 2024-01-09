import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/answer_question/domain/entities/answerable_question.dart' as answerable_question;
import 'package:quiz_lab/features/answer_question/domain/usecases/retrieve_question.dart';
import 'package:quiz_lab/features/answer_question/ui/screens/question_answering/bloc/question_answering_cubit.dart';

void main() {
  late QuizLabLogger logger;
  late RetrieveQuestion retrieveQuestionUseCase;

  late QuestionAnsweringCubit cubit;

  setUp(() {
    logger = _MockQuizLabLogger();
    retrieveQuestionUseCase = _GetSingleQuestionUseCaseMock();

    cubit = QuestionAnsweringCubit(
      logger: logger,
      getSingleQuestionUseCase: retrieveQuestionUseCase,
    );
  });

  tearDown(() {
    cubit.close();
    mocktail.resetMocktailState();
  });

  test('initial state', () {
    expect(cubit.state, isA<QuestionAnsweringInitial>());
  });

  group('loadQuestion', () {
    group('should emit AnsweringScreenError if GetSingleQuestionUseCase fails', () {
      for (final testCase in [('bhv3PXKt', '#20^QDW#'), ('y4a', '*v@FSw0')]) {
        final questionId = testCase.$1;
        final message = testCase.$2;

        test('with $questionId as question id and $message as message', () async {
          when(() => retrieveQuestionUseCase.call(any())).thenAnswer((_) async => Err(message));

          unawaited(
            expectLater(
              cubit.stream,
              emitsInOrder(
                [
                  const QuestionAnsweringLoading(),
                  const QuestionAnsweringError(message: 'Unable to load question'),
                  emitsDone,
                ],
              ),
            ),
          );

          await cubit.loadQuestion(questionId);
          await cubit.close();

          verify(() => retrieveQuestionUseCase.call(questionId)).called(1);
          verify(() => logger.error(message)).called(1);
        });

        for (final question in [
          const answerable_question.AnswerableQuestion(
            id: 'ueH',
            description: 'FfpV5',
            difficulty: QuestionDifficulty.easy,
            answers: [],
            title: 'KD71k',
          ),
          const answerable_question.AnswerableQuestion(
            id: 'J4u',
            description: 'LEW8',
            difficulty: QuestionDifficulty.easy,
            answers: [
              answerable_question.Answer(description: 'ZJt', isCorrect: true, id: r'$K1Bwsw'),
              answerable_question.Answer(description: '2Zi1xU', isCorrect: false, id: r'g3$jA34'),
            ],
            title: 'E8X',
          ),
        ]) {
          test('should emit question updates for $question', () async {
            when(() => retrieveQuestionUseCase.call(any())).thenAnswer((_) async => Ok(question));

            unawaited(
              expectLater(
                cubit.stream,
                emitsInAnyOrder(
                  [
                    const QuestionAnsweringLoading(),
                    isA<QuestionAnsweringQuestionViewModelUpdated>(),
                    emitsDone,
                  ],
                ),
              ),
            );

            await cubit.loadQuestion(questionId);
            await cubit.close();

            verify(() => retrieveQuestionUseCase.call(questionId)).called(1);
          });
        }
      }
    });
  });

  group('onOptionSelected', () {
    for (final optionId in ['A0UbM', 'si68hkfk']) {
      test('should emit expected for $optionId as option id', () async {
        when(() => retrieveQuestionUseCase.call(any())).thenAnswer(
          (_) async => const Ok(
            answerable_question.AnswerableQuestion(
              id: '1zV',
              description: 'FfpV5',
              difficulty: QuestionDifficulty.easy,
              answers: [
                answerable_question.Answer(description: 'ZJt', isCorrect: true, id: 'A0UbM'),
                answerable_question.Answer(description: '2Zi1xU', isCorrect: false, id: 'si68hkfk'),
              ],
              title: 'KD71k',
            ),
          ),
        );

        await cubit.loadQuestion('1zV');

        unawaited(
          expectLater(
            cubit.stream,
            emitsInOrder(
              [
                QuestionAnsweringQuestionViewModelUpdated(
                  viewModel: QuestionViewModel(
                    title: 'KD71k',
                    description: 'FfpV5',
                    difficulty: 'easy',
                    answers: [
                      AnswerViewModel(id: 'A0UbM', title: 'ZJt', isSelected: optionId == 'A0UbM', isCorrect: true),
                      AnswerViewModel(
                        id: 'si68hkfk',
                        title: '2Zi1xU',
                        isSelected: optionId == 'si68hkfk',
                        isCorrect: false,
                      ),
                    ],
                    showResult: false,
                    isAnswerButtonEnabled: true,
                    isAnswerButtonVisible: true,
                  ),
                ),
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

class _GetSingleQuestionUseCaseMock extends mocktail.Mock implements RetrieveQuestion {}
