import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/factories/presentation_mapper_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/question_entity_mapper.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/question_overview_item_view_model_mapper.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/view_models/questions_overview_view_model.dart';

void main() {
  late UseCaseFactory mockUseCaseFactory;
  late PresentationMapperFactory mockMapperFactory;

  late QuestionsOverviewCubit cubit;

  setUp(() {
    mockUseCaseFactory = _MockUseCaseFactory();
    mockMapperFactory = _MockMapperFactory();

    cubit = QuestionsOverviewCubit(
      useCaseFactory: mockUseCaseFactory,
      mapperFactory: mockMapperFactory,
    );
  });

  tearDown(() {
    cubit.close();
    resetMocktailState();
  });

  test('should emit initial state', () {
    expect(cubit.state, isA<QuestionsOverviewInitial>());
  });

  group('updateQuestions', () {
    parameterizedTest(
      'should emit expected states',
      ParameterizedSource.values([
        [
          <List<Question>>[],
          <List<QuestionsOverviewItemViewModel>>[],
          [
            isA<QuestionsOverviewLoading>(),
          ]
        ],
        [
          <List<Question>>[[]],
          <List<QuestionsOverviewItemViewModel>>[
            <QuestionsOverviewItemViewModel>[]
          ],
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
          <List<Question>>[
            [_FakeQuestion(), _FakeQuestion(), _FakeQuestion()],
          ],
          <List<QuestionsOverviewItemViewModel>>[
            <QuestionsOverviewItemViewModel>[
              _FakeQuestionOverviewItemViewModel(),
              _FakeQuestionOverviewItemViewModel(),
              _FakeQuestionOverviewItemViewModel(),
            ]
          ],
          [
            isA<QuestionsOverviewLoading>(),
            isA<QuestionsOverviewViewModelUpdated>().having(
              (state) => state.viewModel.questions,
              'questions',
              [
                _FakeQuestionOverviewItemViewModel(),
                _FakeQuestionOverviewItemViewModel(),
                _FakeQuestionOverviewItemViewModel(),
              ],
            ).having(
              (state) => state.viewModel.isRandomQuestionButtonEnabled,
              'isRandomQuestionButtonEnabled',
              true,
            ),
          ]
        ],
        [
          <List<Question>>[
            [_FakeQuestion(), _FakeQuestion(), _FakeQuestion()],
            [_FakeQuestion(), _FakeQuestion(), _FakeQuestion()],
          ],
          <List<QuestionsOverviewItemViewModel>>[
            <QuestionsOverviewItemViewModel>[
              _FakeQuestionOverviewItemViewModel(),
              _FakeQuestionOverviewItemViewModel(),
              _FakeQuestionOverviewItemViewModel(),
            ],
            <QuestionsOverviewItemViewModel>[
              _FakeQuestionOverviewItemViewModel(),
              _FakeQuestionOverviewItemViewModel(),
              _FakeQuestionOverviewItemViewModel(),
            ],
          ],
          [
            isA<QuestionsOverviewLoading>(),
            isA<QuestionsOverviewViewModelUpdated>().having(
              (state) => state.viewModel.questions,
              'questions',
              <QuestionsOverviewItemViewModel>[
                _FakeQuestionOverviewItemViewModel(),
                _FakeQuestionOverviewItemViewModel(),
                _FakeQuestionOverviewItemViewModel(),
              ],
            ).having(
              (state) => state.viewModel.isRandomQuestionButtonEnabled,
              'isRandomQuestionButtonEnabled',
              true,
            ),
          ]
        ],
      ]),
      (values) {
        final questions = values[0] as List<List<Question>>;
        final overviewItemsToReturn =
            values[1] as List<List<QuestionsOverviewItemViewModel>>;
        final expectedStates = values[2] as List<Matcher>;

        final mockWatchAllQuestionsUseCase = _MockWatchAllQuestionsUseCase();
        final mockQuestionOverviewItemViewModelMapper =
            _MockQuestionOverviewItemViewModelMapper();

        when(() => mockMapperFactory.makeQuestionOverviewItemViewModelMapper())
            .thenReturn(mockQuestionOverviewItemViewModelMapper);

        when(() => mockUseCaseFactory.makeWatchAllQuestionsUseCase())
            .thenReturn(mockWatchAllQuestionsUseCase);

        when(
          () => mockQuestionOverviewItemViewModelMapper
              .multipleFromQuestionEntity(any()),
        ).thenAnswer((_) => overviewItemsToReturn.removeAt(0));

        when(mockWatchAllQuestionsUseCase.execute)
            .thenReturn(Result.ok(Stream.fromIterable(questions)));

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        cubit.updateQuestions();
      },
    );

    parameterizedTest(
      'should emit error if use case fails',
      ParameterizedSource.values([
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
      ]),
      (values) {
        final message = values[0] as String;
        final expectedStates = values[1] as List<Matcher>;

        final mockWatchAllQuestionsUseCase = _MockWatchAllQuestionsUseCase();
        final mockQuestionOverviewItemViewModelMapper =
            _MockQuestionOverviewItemViewModelMapper();

        when(() => mockMapperFactory.makeQuestionOverviewItemViewModelMapper())
            .thenReturn(mockQuestionOverviewItemViewModelMapper);

        when(() => mockUseCaseFactory.makeWatchAllQuestionsUseCase())
            .thenReturn(mockWatchAllQuestionsUseCase);

        when(mockWatchAllQuestionsUseCase.execute).thenReturn(
          Result.err(WatchAllQuestionsFailure.generic(message: message)),
        );

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        cubit.updateQuestions();
      },
    );
  });

  group('removeQuestion', () {
    parameterizedTest(
      'should emit expected states',
      ParameterizedSource.values([
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
      ]),
      (values) {
        final questionId = values[0] as String;
        final expectedStates = values[1] as List<Matcher>;

        final mockDeleteQuestionUseCase = _MockDeleteQuestionUseCase();

        when(() => mockUseCaseFactory.makeDeleteQuestionUseCase())
            .thenReturn(mockDeleteQuestionUseCase);

        when(() => mockDeleteQuestionUseCase.execute(questionId))
            .thenAnswer((_) async {});

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        cubit.removeQuestion(
          _FakeQuestionOverviewItemViewModelWithId(id: questionId),
        );
      },
    );
  });

  group('onQuestionSaved', () {
    setUp(() => registerFallbackValue(_FakeQuestion()));

    parameterizedTest(
      'should emit expected states',
      ParameterizedSource.values([
        [
          const QuestionsOverviewItemViewModel(
            id: '',
            difficulty: '',
            shortDescription: '',
            description: '',
            categories: [],
          ),
          Result<Question, QuestionEntityMapperFailure>.err(
            QuestionEntityMapperFailure.unexpectedDifficultyValue(value: ''),
          ),
          Result<Unit, UpdateQuestionUseCaseFailure>.err(
            UpdateQuestionUseCaseFailure.repositoryFailure(''),
          ),
          <Matcher>[]
        ],
        [
          const QuestionsOverviewItemViewModel(
            id: '',
            difficulty: '',
            shortDescription: 'Bqdxm%',
            description: '',
            categories: [],
          ),
          Result<Question, QuestionEntityMapperFailure>.err(
            QuestionEntityMapperFailure.unexpectedDifficultyValue(value: ''),
          ),
          Result<Unit, UpdateQuestionUseCaseFailure>.err(
            UpdateQuestionUseCaseFailure.repositoryFailure(''),
          ),
          [
            isA<QuestionsOverviewLoading>(),
            isA<QuestionsOverviewErrorOccurred>().having(
              (state) => state.message,
              'message',
              QuestionEntityMapperFailure.unexpectedDifficultyValue(
                value: '',
              ).message,
            ),
          ]
        ],
        [
          const QuestionsOverviewItemViewModel(
            id: '',
            difficulty: '',
            shortDescription: 'd5jeil',
            description: '',
            categories: [],
          ),
          Result<Question, QuestionEntityMapperFailure>.err(
            QuestionEntityMapperFailure.unexpectedDifficultyValue(
              value: 'Gjz7RKKZ',
            ),
          ),
          Result<Unit, UpdateQuestionUseCaseFailure>.err(
            UpdateQuestionUseCaseFailure.repositoryFailure(''),
          ),
          [
            isA<QuestionsOverviewLoading>(),
            isA<QuestionsOverviewErrorOccurred>().having(
              (state) => state.message,
              'message',
              QuestionEntityMapperFailure.unexpectedDifficultyValue(
                value: 'Gjz7RKKZ',
              ).message,
            ),
          ]
        ],
        [
          const QuestionsOverviewItemViewModel(
            id: '',
            difficulty: '',
            shortDescription: 'd5jeil',
            description: '',
            categories: [],
          ),
          Result<Question, QuestionEntityMapperFailure>.ok(_FakeQuestion()),
          Result<Unit, UpdateQuestionUseCaseFailure>.err(
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
          const QuestionsOverviewItemViewModel(
            id: '',
            difficulty: '',
            shortDescription: '&Fl0',
            description: '',
            categories: [],
          ),
          Result<Question, QuestionEntityMapperFailure>.ok(_FakeQuestion()),
          Result<Unit, UpdateQuestionUseCaseFailure>.err(
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
      ]),
      (values) {
        final viewModel = values[0] as QuestionsOverviewItemViewModel;
        final questionEntityMapperResult =
            values[1] as Result<Question, QuestionEntityMapperFailure>;
        final updateQuestionUseCaseResult =
            values[2] as Result<Unit, UpdateQuestionUseCaseFailure>;
        final expectedStates = values[3] as List<Matcher>;

        final mockQuestionEntityMapper = _MockQuestionEntityMapper();
        final mockUpdateQuestionUseCase = _MockUpdateQuestionUseCase();

        when(() => mockMapperFactory.makeQuestionEntityMapper())
            .thenReturn(mockQuestionEntityMapper);

        when(() => mockUseCaseFactory.makeUpdateQuestionUseCase())
            .thenReturn(mockUpdateQuestionUseCase);

        when(
          () => mockQuestionEntityMapper
              .singleFromQuestionOverviewItemViewModel(viewModel),
        ).thenReturn(questionEntityMapperResult);

        when(() => mockUpdateQuestionUseCase.execute(any()))
            .thenAnswer((_) async => updateQuestionUseCaseResult);

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        cubit.onQuestionSaved(viewModel);
      },
    );
  });
}

class _FakeQuestion extends Fake with EquatableMixin implements Question {
  @override
  List<Object?> get props => [];
}

class _FakeQuestionOverviewItemViewModel extends Fake
    with EquatableMixin
    implements QuestionsOverviewItemViewModel {
  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}

class _FakeQuestionOverviewItemViewModelWithId extends Fake
    implements QuestionsOverviewItemViewModel {
  _FakeQuestionOverviewItemViewModelWithId({
    required this.id,
  }) : super();

  @override
  final String id;
}

class _MockUseCaseFactory extends Mock implements UseCaseFactory {}

class _MockMapperFactory extends Mock implements PresentationMapperFactory {}

class _MockQuestionOverviewItemViewModelMapper extends Mock
    implements QuestionOverviewItemViewModelMapper {}

class _MockQuestionEntityMapper extends Mock implements QuestionEntityMapper {}

class _MockWatchAllQuestionsUseCase extends Mock
    implements WatchAllQuestionsUseCase {}

class _MockDeleteQuestionUseCase extends Mock implements DeleteQuestionUseCase {
}

class _MockUpdateQuestionUseCase extends Mock implements UpdateQuestionUseCase {
}
