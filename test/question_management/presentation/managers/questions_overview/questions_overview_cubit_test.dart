import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/factories/use_case_factory.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/factories/mapper_factory.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/mappers/question_overview_item_view_model_mapper.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/questions_overview_cubit.dart';
import 'package:quiz_lab/features/question_management/presentation/managers/questions_overview/view_models/question_overview_item_view_model.dart';

void main() {
  late UseCaseFactory mockUseCaseFactory;
  late MapperFactory mockMapperFactory;

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
    expect(cubit.state, QuestionsOverviewState.initial());
  });

  group('updateQuestions', () {
    parameterizedTest(
      'should emit expected states',
      ParameterizedSource.values([
        [
          <List<Question>>[],
          <List<QuestionOverviewItemViewModel>>[],
          [
            QuestionsOverviewState.loading(),
          ]
        ],
        [
          <List<Question>>[[]],
          <List<QuestionOverviewItemViewModel>>[
            <QuestionOverviewItemViewModel>[]
          ],
          [
            QuestionsOverviewState.loading(),
            QuestionsOverviewState.questionListUpdated(questions: const []),
          ]
        ],
        [
          <List<Question>>[
            [_FakeQuestion(), _FakeQuestion(), _FakeQuestion()],
          ],
          <List<QuestionOverviewItemViewModel>>[
            <QuestionOverviewItemViewModel>[
              _FakeQuestionOverviewItemViewModel(),
              _FakeQuestionOverviewItemViewModel(),
              _FakeQuestionOverviewItemViewModel(),
            ]
          ],
          [
            QuestionsOverviewState.loading(),
            QuestionsOverviewState.questionListUpdated(
              questions: [
                _FakeQuestionOverviewItemViewModel(),
                _FakeQuestionOverviewItemViewModel(),
                _FakeQuestionOverviewItemViewModel(),
              ],
            ),
          ]
        ],
        [
          <List<Question>>[
            [_FakeQuestion(), _FakeQuestion(), _FakeQuestion()],
            [_FakeQuestion(), _FakeQuestion(), _FakeQuestion()],
          ],
          <List<QuestionOverviewItemViewModel>>[
            <QuestionOverviewItemViewModel>[
              _FakeQuestionOverviewItemViewModel(),
              _FakeQuestionOverviewItemViewModel(),
              _FakeQuestionOverviewItemViewModel(),
            ],
            <QuestionOverviewItemViewModel>[
              _FakeQuestionOverviewItemViewModel(),
              _FakeQuestionOverviewItemViewModel(),
              _FakeQuestionOverviewItemViewModel(),
            ],
          ],
          [
            QuestionsOverviewState.loading(),
            QuestionsOverviewState.questionListUpdated(
              questions: [
                _FakeQuestionOverviewItemViewModel(),
                _FakeQuestionOverviewItemViewModel(),
                _FakeQuestionOverviewItemViewModel(),
              ],
            ),
          ]
        ],
      ]),
      (values) {
        final questions = values[0] as List<List<Question>>;
        final overviewItemsToReturn =
            values[1] as List<List<QuestionOverviewItemViewModel>>;
        final expectedStates = values[2] as List<QuestionsOverviewState>;

        final questionStreamController = StreamController<List<Question>>();

        questions.forEach(questionStreamController.add);

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
            .thenReturn(Result.ok(questionStreamController.stream));

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        cubit.updateQuestions();
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
    implements QuestionOverviewItemViewModel {
  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}

class _MockUseCaseFactory extends Mock implements UseCaseFactory {}

class _MockMapperFactory extends Mock implements MapperFactory {}

class _MockQuestionOverviewItemViewModelMapper extends Mock
    implements QuestionOverviewItemViewModelMapper {}

class _MockWatchAllQuestionsUseCase extends Mock
    implements WatchAllQuestionsUseCase {}
