import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/bloc/questions_overview/view_models/questions_overview_view_model.dart';

void main() {
  late UpdateQuestionUseCase updateQuestionUseCaseMock;
  late DeleteQuestionUseCase deleteQuestionUseCaseMock;
  late WatchAllQuestionsUseCase watchAllQuestionsUseCaseMock;

  late QuestionsOverviewCubit cubit;

  setUp(() {
    updateQuestionUseCaseMock = _UpdateQuestionUseCaseMock();
    deleteQuestionUseCaseMock = _DeleteQuestionUseCaseMock();
    watchAllQuestionsUseCaseMock = _WatchAllQuestionsUseCaseMock();

    cubit = QuestionsOverviewCubit(
      updateQuestionUseCase: updateQuestionUseCaseMock,
      deleteQuestionUseCase: deleteQuestionUseCaseMock,
      watchAllQuestionsUseCase: watchAllQuestionsUseCaseMock,
    );
  });

  tearDown(() {
    cubit.close();
    mocktail.resetMocktailState();
  });

  test(
    'should emit initial state',
    () => expect(cubit.state, isA<QuestionsOverviewInitial>()),
  );

  group('updateQuestions', () {
    for (final values in [
      [
        <List<Question>>[],
        [
          isA<QuestionsOverviewLoading>(),
        ]
      ],
      [
        <List<Question>>[[]],
        [
          isA<QuestionsOverviewLoading>(),
          isA<QuestionsOverviewViewModelUpdated>()
              .having(
                (state) => state.viewModel.questions,
                'questions',
                isEmpty,
              )
              .having(
                (state) => state.viewModel.isRandomQuestionButtonEnabled,
                'isRandomQuestionButtonEnabled',
                false,
              ),
        ]
      ],
      [
        [
          [
            _DummyQuestion(),
            _DummyQuestion(),
            _DummyQuestion(),
          ],
        ],
        [
          isA<QuestionsOverviewLoading>(),
          isA<QuestionsOverviewViewModelUpdated>().having(
            (state) => state.viewModel.questions,
            'questions',
            [
              isA<QuestionsOverviewItemViewModel>(),
              isA<QuestionsOverviewItemViewModel>(),
              isA<QuestionsOverviewItemViewModel>(),
            ],
          ).having(
            (state) => state.viewModel.isRandomQuestionButtonEnabled,
            'isRandomQuestionButtonEnabled',
            true,
          ),
        ]
      ],
      [
        [
          [_DummyQuestion(), _DummyQuestion(), _DummyQuestion()],
          [_DummyQuestion(), _DummyQuestion(), _DummyQuestion()],
        ],
        [
          isA<QuestionsOverviewLoading>(),
          isA<QuestionsOverviewViewModelUpdated>().having(
            (state) => state.viewModel.questions,
            'questions',
            [
              isA<QuestionsOverviewItemViewModel>(),
              isA<QuestionsOverviewItemViewModel>(),
              isA<QuestionsOverviewItemViewModel>(),
            ],
          ).having(
            (state) => state.viewModel.isRandomQuestionButtonEnabled,
            'isRandomQuestionButtonEnabled',
            true,
          ),
        ]
      ],
    ]) {
      final questions = values[0] as List<List<Question>>;
      final expectedStates = values[1] as List<Matcher>;

      test('should emit expected states: $expectedStates', () {
        mocktail.when(watchAllQuestionsUseCaseMock.execute).thenAnswer(
              (_) async => Ok(Stream.fromIterable(questions)),
            );

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        cubit.updateQuestions();
      });
    }

    group(
      'should emit error if use case fails',
      () {
        for (final values in [
          [
            '',
            [
              isA<QuestionsOverviewLoading>(),
              isA<QuestionsOverviewErrorOccurred>().having(
                (state) => state.message,
                'message',
                '',
              ),
            ],
          ],
          [
            'v^s',
            [
              isA<QuestionsOverviewLoading>(),
              isA<QuestionsOverviewErrorOccurred>().having(
                (state) => state.message,
                'message',
                'v^s',
              ),
            ],
          ],
        ]) {
          test(values.toString(), () {
            final message = values[0] as String;
            final expectedStates = values[1] as List<Matcher>;

            mocktail.when(watchAllQuestionsUseCaseMock.execute).thenAnswer(
                  (_) async => Err(
                    WatchAllQuestionsFailure.generic(message: message),
                  ),
                );

            expectLater(cubit.stream, emitsInOrder(expectedStates));

            cubit.updateQuestions();
          });
        }
      },
    );
  });

  group('removeQuestion', () {
    group(
      'should emit expected states',
      () {
        for (final values in [
          [
            '',
            [
              isA<QuestionsOverviewLoading>(),
            ]
          ],
          [
            '@Js',
            [
              isA<QuestionsOverviewLoading>(),
            ]
          ],
        ]) {
          test(values.toString(), () {
            final questionId = values[0] as String;
            final expectedStates = values[1] as List<Matcher>;

            final questionOverviewItemViewModelMock = _QuestionOverviewItemViewModelMock();

            mocktail.when(() => questionOverviewItemViewModelMock.id).thenReturn(questionId);

            mocktail.when(() => deleteQuestionUseCaseMock.execute(questionId)).thenAnswer((_) async {});

            expectLater(cubit.stream, emitsInOrder(expectedStates));

            cubit.removeQuestion(questionOverviewItemViewModelMock);
          });
        }
      },
    );
  });

  group('onQuestionSaved', () {
    setUp(() => mocktail.registerFallbackValue(_QuestionMock()));

    test(
      'should emit nothing if description is emtpy',
      () {
        final viewModelMock = _QuestionOverviewItemViewModelMock();

        mocktail.when(() => viewModelMock.shortDescription).thenReturn('');

        expectLater(cubit.stream, emitsInOrder([]));

        cubit.onQuestionSaved(viewModelMock);
      },
    );

    group(
      'should emit expected states',
      () {
        for (final values in [
          [
            Err<Unit, UpdateQuestionUseCaseFailure>(
              UpdateQuestionUseCaseFailure.repositoryFailure(''),
            ),
            [
              isA<QuestionsOverviewLoading>(),
            ]
          ],
          [
            Err<Unit, UpdateQuestionUseCaseFailure>(
              UpdateQuestionUseCaseFailure.repositoryFailure(''),
            ),
            [
              isA<QuestionsOverviewLoading>(),
            ]
          ],
          [
            Err<Unit, UpdateQuestionUseCaseFailure>(
              UpdateQuestionUseCaseFailure.repositoryFailure(''),
            ),
            [
              isA<QuestionsOverviewLoading>(),
              isA<QuestionsOverviewErrorOccurred>().having(
                (state) => state.message,
                'message',
                UpdateQuestionUseCaseFailure.repositoryFailure('').message,
              ),
            ]
          ],
          [
            Err<Unit, UpdateQuestionUseCaseFailure>(
              UpdateQuestionUseCaseFailure.repositoryFailure('#1q'),
            ),
            [
              isA<QuestionsOverviewLoading>(),
              isA<QuestionsOverviewErrorOccurred>().having(
                (state) => state.message,
                'message',
                UpdateQuestionUseCaseFailure.repositoryFailure('#1q').message,
              ),
            ]
          ],
        ]) {
          test(values.toString(), () {
            final updateQuestionUseCaseResult = values[0] as Result<Unit, UpdateQuestionUseCaseFailure>;
            final expectedStates = values[1] as List<Matcher>;

            final viewModelMock = _QuestionOverviewItemViewModelMock();
            final questionMock = _QuestionMock();

            mocktail.when(() => viewModelMock.shortDescription).thenReturn('gImVFe1#');

            mocktail.when(viewModelMock.toQuestion).thenReturn(questionMock);

            mocktail
                .when(() => updateQuestionUseCaseMock.execute(mocktail.any()))
                .thenAnswer((_) async => updateQuestionUseCaseResult);

            expectLater(cubit.stream, emitsInOrder(expectedStates));

            cubit.onQuestionSaved(viewModelMock);
          });
        }
      },
    );
  });
}

class _QuestionMock extends mocktail.Mock implements Question {}

class _QuestionOverviewItemViewModelMock extends mocktail.Mock implements QuestionsOverviewItemViewModel {}

class _UpdateQuestionUseCaseMock extends mocktail.Mock implements UpdateQuestionUseCase {}

class _DeleteQuestionUseCaseMock extends mocktail.Mock implements DeleteQuestionUseCase {}

class _WatchAllQuestionsUseCaseMock extends mocktail.Mock implements WatchAllQuestionsUseCase {}

class _DummyQuestion extends Question {
  _DummyQuestion()
      : super(
          id: const QuestionId('6Mx'),
          categories: [
            const QuestionCategory(value: r'$za7$'),
            const QuestionCategory(value: 'jZ8'),
            const QuestionCategory(value: '@q*#@SD5'),
          ],
          description: 'u@V!i!&',
          difficulty: QuestionDifficulty.unknown,
          answerOptions: [
            const AnswerOption(description: '*L6', isCorrect: false),
            const AnswerOption(description: r'L$e5o', isCorrect: true),
            const AnswerOption(description: 'mu!pS2', isCorrect: false),
          ],
          shortDescription: 'GE#y9',
        );
}
