import 'dart:async';

import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/factories/repository_factory.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';

void main() {
  late RepositoryFactory mockRepositoryFactory;
  late WatchAllQuestionsUseCase useCase;

  setUp(() {
    mockRepositoryFactory = _MockRepositoryFactory();
    useCase = WatchAllQuestionsUseCase(
      repositoryFactory: mockRepositoryFactory,
    );
  });

  tearDown(mocktail.resetMocktailState);

  group('err flow', () {
    parameterizedTest(
      'question repository fails',
      ParameterizedSource.values([
        [
          QuestionRepositoryFailure.unableToWatchAll(message: ''),
          WatchAllQuestionsFailure.generic(message: '')
        ],
        [
          QuestionRepositoryFailure.unableToWatchAll(message: 'f9T'),
          WatchAllQuestionsFailure.generic(message: 'f9T')
        ],
      ]),
      (values) {
        final repositoryFailure = values[0] as QuestionRepositoryFailure;
        final expectedFailure = values[1] as WatchAllQuestionsFailure;

        final mockQuestionRepository = _MockQuestionRepository();

        mocktail
            .when(() => mockRepositoryFactory.makeQuestionRepository())
            .thenReturn(mockQuestionRepository);

        mocktail
            .when(mockQuestionRepository.watchAll)
            .thenReturn(Result.err(repositoryFailure));

        final result = useCase.execute();

        expect(result.isErr, true);
        expect(result.err, expectedFailure);
      },
    );
  });

  group('ok flow', () {
    parameterizedTest(
      'Use case should return stream from repository',
      ParameterizedSource.value([
        <List<Question>>[],
        [
          [
            const Question(
              id: '15e194a8-8fa9-4b04-af8f-8d71491ac7e8',
              shortDescription: 'shortDescription',
              description: 'description',
              answerOptions: [],
              difficulty: QuestionDifficulty.hard,
              categories: [],
            )
          ]
        ],
        [
          [
            const Question(
              id: '15e194a8-8fa9-4b04-af8f-8d71491ac7e8',
              shortDescription: 'shortDescription',
              description: 'description',
              answerOptions: [],
              difficulty: QuestionDifficulty.hard,
              categories: [],
            ),
            const Question(
              id: '56d6a3c9-ebd5-4572-9c86-da328b986927',
              shortDescription: 'shortDescription',
              description: 'description',
              answerOptions: [],
              difficulty: QuestionDifficulty.hard,
              categories: [],
            ),
            const Question(
              id: 'd377713b-dfb7-4c22-88a4-3f6d340285dc',
              shortDescription: 'shortDescription',
              description: 'description',
              answerOptions: [],
              difficulty: QuestionDifficulty.hard,
              categories: [],
            ),
          ]
        ],
      ]),
      (values) async {
        final streamValues = values[0] as List<List<Question>>;
        final stream = Stream.fromIterable(streamValues);

        final mockQuestionRepository = _MockQuestionRepository();

        mocktail
            .when(() => mockRepositoryFactory.makeQuestionRepository())
            .thenReturn(mockQuestionRepository);

        mocktail
            .when(mockQuestionRepository.watchAll)
            .thenReturn(Result.ok(stream));

        final result = useCase.execute();

        expect(result.isOk, isTrue);

        final actualStream = result.ok;
        unawaited(expectLater(actualStream, emitsInOrder(streamValues)));
      },
    );
  });
}

class _MockRepositoryFactory extends mocktail.Mock
    implements RepositoryFactory {}

class _MockQuestionRepository extends mocktail.Mock
    implements QuestionRepository {}
