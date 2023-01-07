import 'dart:async';

import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/get_single_question_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/question_display_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/question_display/view_models/question_display_view_model.dart';

void main() {
  late UseCaseFactory useCaseFactoryMock;

  late QuestionDisplayCubit cubit;

  setUp(() {
    useCaseFactoryMock = _UseCaseFactoryMock();
    cubit = QuestionDisplayCubit(useCaseFactory: useCaseFactoryMock);
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
          final getSingleQuestionUseCaseMock = _GetSingleQuestionUseCaseMock();

          mocktail
              .when(() => getSingleQuestionUseCaseMock.execute(questionId))
              .thenAnswer((_) async => const Result.err('5A5J'));

          mocktail
              .when(() => useCaseFactoryMock.makeGetSingleQuestionUseCase())
              .thenReturn(getSingleQuestionUseCaseMock);

          unawaited(
            expectLater(
              cubit.stream,
              emitsInOrder(
                [
                  isA<QuestionDisplayFailure>(),
                ],
              ),
            ),
          );

          await cubit.loadQuestion(questionId);
        },
      );
    });

    group('ok flow', () {
      parameterizedTest(
        'should emit QuestionDisplayViewModelSubjectUpdated with expected '
        'viewModel',
        ParameterizedSource.values([
          [
            const Question(
              id: '',
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
                  title: '',
                  isSelected: false,
                  isCorrect: false,
                ),
                QuestionDisplayOptionViewModel(
                  title: '',
                  isSelected: false,
                  isCorrect: true,
                ),
              ],
              answerButtonIsEnabled: false,
            )
          ],
          [
            const Question(
              id: r'%$CvEPVq',
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
                  title: '3',
                  isSelected: false,
                  isCorrect: false,
                ),
                QuestionDisplayOptionViewModel(
                  title: '9',
                  isSelected: false,
                  isCorrect: true,
                ),
                QuestionDisplayOptionViewModel(
                  title: '27',
                  isSelected: false,
                  isCorrect: false,
                ),
                QuestionDisplayOptionViewModel(
                  title: '81',
                  isSelected: false,
                  isCorrect: false,
                ),
              ],
              answerButtonIsEnabled: false,
            )
          ],
        ]),
        (values) async {
          final question = values[0] as Question;
          final expectedViewModel = values[1] as QuestionDisplayViewModel;

          final getSingleQuestionUseCaseMock = _GetSingleQuestionUseCaseMock();

          mocktail
              .when(() => getSingleQuestionUseCaseMock.execute(question.id))
              .thenAnswer((_) async => Result.ok(question));

          mocktail
              .when(() => useCaseFactoryMock.makeGetSingleQuestionUseCase())
              .thenReturn(getSingleQuestionUseCaseMock);

          unawaited(
            expectLater(
              cubit.stream,
              emitsInOrder(
                [
                  isA<QuestionDisplayViewModelSubjectUpdated>()
                      .having(
                        (state) => state.subject.value.title,
                        'title',
                        expectedViewModel.title,
                      )
                      .having(
                        (state) => state.subject.value.description,
                        'description',
                        expectedViewModel.description,
                      )
                      .having(
                        (state) => state.subject.value.difficulty,
                        'difficulty',
                        expectedViewModel.difficulty,
                      )
                      .having(
                        (state) => state.subject.value.answerButtonIsEnabled,
                        'answerButtonIsEnabled',
                        expectedViewModel.answerButtonIsEnabled,
                      )
                      .having(
                        (state) => state.subject.value.options,
                        'options',
                        containsAll(expectedViewModel.options),
                      )
                ],
              ),
            ),
          );

          await cubit.loadQuestion(question.id);
        },
      );
    });
  });
}

class _UseCaseFactoryMock extends mocktail.Mock implements UseCaseFactory {}

class _GetSingleQuestionUseCaseMock extends mocktail.Mock
    implements GetSingleQuestionUseCase {}
