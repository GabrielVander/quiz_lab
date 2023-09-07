import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/get_single_question_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/answering_screen/bloc/answering_screen_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/screens/answering_screen/bloc/view_models/question_display_view_model.dart';

void main() {
  late QuizLabLogger logger;
  late GetSingleQuestionUseCase getSingleQuestionUseCaseMock;

  late AnsweringScreenCubit cubit;

  setUp(() {
    logger = _MockQuizLabLogger();
    getSingleQuestionUseCaseMock = _GetSingleQuestionUseCaseMock();

    cubit = AnsweringScreenCubit(
      logger: logger,
      getSingleQuestionUseCase: getSingleQuestionUseCaseMock,
    );
  });

  tearDown(() {
    cubit.close();
    mocktail.resetMocktailState();
  });

  test('initial state', () {
    expect(cubit.state, isA<QuestionDisplayInitial>());
  });

  group('loadQuestion', () {
    group('err flow', () {
      test(
        'should emit QuestionDisplayFailure if GetSingleQuestionUseCase fails',
        () async {
          const questionId = 'tHqgcfIX';

          mocktail
              .when(() => getSingleQuestionUseCaseMock.execute(questionId))
              .thenAnswer((_) async => const Err(unit));

          unawaited(
            expectLater(
              cubit.stream,
              emitsInOrder(
                [
                  isA<QuestionDisplayError>(),
                ],
              ),
            ),
          );

          await cubit.loadQuestion(questionId);
        },
      );
    });

    group('ok flow', () {
      group(
        'should emit QuestionDisplayViewModelSubjectUpdated with expected viewModel',
        () {
          for (final values in [
            [
              const Question(
                id: QuestionId(''),
                shortDescription: '',
                description: '',
                difficulty: QuestionDifficulty.easy,
                answerOptions: [
                  AnswerOption(description: '', isCorrect: false),
                  AnswerOption(description: '', isCorrect: true),
                ],
                categories: [],
              ),
              const QuestionDisplayViewModel(
                title: '',
                description: '',
                difficulty: 'easy',
                options: [
                  QuestionDisplayOptionViewModel(
                    id: '',
                    title: '',
                    isSelected: false,
                    isCorrect: false,
                  ),
                  QuestionDisplayOptionViewModel(
                    id: '',
                    title: '',
                    isSelected: false,
                    isCorrect: true,
                  ),
                ],
                answerButtonIsEnabled: false,
              ),
            ],
            [
              const Question(
                id: QuestionId(r'%$CvEPVq'),
                shortDescription: 'Equivalence',
                description: 'Which number is equivalent to 3^(4)÷3^(2)?',
                difficulty: QuestionDifficulty.easy,
                answerOptions: [
                  AnswerOption(description: '3', isCorrect: false),
                  AnswerOption(description: '9', isCorrect: true),
                  AnswerOption(description: '27', isCorrect: false),
                  AnswerOption(description: '81', isCorrect: false),
                ],
                categories: [],
              ),
              const QuestionDisplayViewModel(
                title: 'Equivalence',
                description: 'Which number is equivalent to 3^(4)÷3^(2)?',
                difficulty: 'easy',
                options: [
                  QuestionDisplayOptionViewModel(
                    id: '',
                    title: '3',
                    isSelected: false,
                    isCorrect: false,
                  ),
                  QuestionDisplayOptionViewModel(
                    id: '',
                    title: '9',
                    isSelected: false,
                    isCorrect: true,
                  ),
                  QuestionDisplayOptionViewModel(
                    id: '',
                    title: '27',
                    isSelected: false,
                    isCorrect: false,
                  ),
                  QuestionDisplayOptionViewModel(
                    id: '',
                    title: '81',
                    isSelected: false,
                    isCorrect: false,
                  ),
                ],
                answerButtonIsEnabled: false,
              ),
            ],
          ]) {
            test(values.toString(), () async {
              final question = values[0] as Question;
              final expectedViewModel = values[1] as QuestionDisplayViewModel;

              mocktail
                  .when(() => getSingleQuestionUseCaseMock.execute(question.id.value))
                  .thenAnswer((_) async => Ok(question));

              unawaited(
                expectLater(
                  cubit.stream,
                  emitsInOrder(
                    [
                      isA<QuestionDisplayQuestionInformationUpdated>()
                          .having(
                            (state) => state.title,
                            'title',
                            expectedViewModel.title,
                          )
                          .having(
                            (state) => state.description,
                            'description',
                            expectedViewModel.description,
                          )
                          .having(
                            (state) => state.difficulty,
                            'difficulty',
                            expectedViewModel.difficulty,
                          ),
                    ],
                  ),
                ),
              );

              await cubit.loadQuestion(question.id.value);
            });
          }
        },
      );
    });
  });

  group('goHome', () {
    test('should emit QuestionDisplayGoHome', () async {
      unawaited(
        expectLater(
          cubit.stream,
          emitsInOrder(
            [
              isA<QuestionDisplayGoHome>(),
            ],
          ),
        ),
      );

      cubit.onGoHome();
    });
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _GetSingleQuestionUseCaseMock extends mocktail.Mock implements GetSingleQuestionUseCase {}
