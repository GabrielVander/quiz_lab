import 'dart:async';

import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/factories/repository_factory.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';

void main() {
  late QuizLabLogger loggerMock;
  late RepositoryFactory mockRepositoryFactory;
  late WatchAllQuestionsUseCase useCase;

  setUp(() {
    loggerMock = _LoggerMock();
    mockRepositoryFactory = _MockRepositoryFactory();
    useCase = WatchAllQuestionsUseCase(
      logger: loggerMock,
      repositoryFactory: mockRepositoryFactory,
    );
  });

  tearDown(mocktail.resetMocktailState);

  test('should log on process start', () {
    final mockQuestionRepository = _MockQuestionRepository();

    mocktail
        .when(() => mockRepositoryFactory.makeQuestionRepository())
        .thenReturn(mockQuestionRepository);

    mocktail.when(mockQuestionRepository.watchAll).thenReturn(
          Result.err(
            QuestionRepositoryFailure.unableToWatchAll(message: 'message'),
          ),
        );

    useCase.execute();

    mocktail
        .verify(
          () => loggerMock.logInfo('Watching all questions...'),
        )
        .called(1);
  });

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

        mocktail
            .verify(() => loggerMock.logError(repositoryFailure.message))
            .called(1);
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

        // actualStream!.listen(null);

        mocktail.verifyNever(() => loggerMock.logError(mocktail.any()));

        for (final questions in streamValues) {
          await mocktail.untilCalled(
            () => loggerMock.logInfo(
              'Retrieved ${questions.length} questions',
            ),
          );
        }
      },
    );
  });
}

class _MockRepositoryFactory extends mocktail.Mock
    implements RepositoryFactory {}

class _MockQuestionRepository extends mocktail.Mock
    implements QuestionRepository {}

class _LoggerMock extends mocktail.Mock implements QuizLabLogger {}
