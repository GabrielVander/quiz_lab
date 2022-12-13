import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';

void main() {
  late QuestionRepository dummyQuestionRepository;
  late WatchAllQuestionsUseCase useCase;

  setUp(() {
    dummyQuestionRepository = DummyQuestionRepository();
    useCase =
        WatchAllQuestionsUseCase(questionRepository: dummyQuestionRepository);
  });

  tearDown(resetMocktailState);

  group('Err flow', () {
    parameterizedTest(
      'Question repository fails',
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

        when(() => dummyQuestionRepository.watchAll())
            .thenReturn(Result.err(repositoryFailure));

        final result = useCase.execute();

        expect(result.isErr, true);
        expect(result.err, expectedFailure);
      },
    );
  });

  group('Ok flow', () {
    parameterizedTest(
      'Use case should return stream from repository',
      ParameterizedSource.value([
        const Stream<List<Question>>.empty(),
        Stream.fromIterable([
          [
            Question(
              id: '15e194a8-8fa9-4b04-af8f-8d71491ac7e8',
              shortDescription: 'shortDescription',
              description: 'description',
              answerOptions: const [],
              difficulty: QuestionDifficulty.hard,
              categories: const [],
            )
          ]
        ]),
        Stream.fromIterable([
          [
            Question(
              id: '15e194a8-8fa9-4b04-af8f-8d71491ac7e8',
              shortDescription: 'shortDescription',
              description: 'description',
              answerOptions: const [],
              difficulty: QuestionDifficulty.hard,
              categories: const [],
            ),
            Question(
              id: '56d6a3c9-ebd5-4572-9c86-da328b986927',
              shortDescription: 'shortDescription',
              description: 'description',
              answerOptions: const [],
              difficulty: QuestionDifficulty.hard,
              categories: const [],
            ),
            Question(
              id: 'd377713b-dfb7-4c22-88a4-3f6d340285dc',
              shortDescription: 'shortDescription',
              description: 'description',
              answerOptions: const [],
              difficulty: QuestionDifficulty.hard,
              categories: const [],
            ),
          ]
        ]),
      ]),
      (values) {
        final stream = values[0] as Stream<List<Question>>;

        when(() => dummyQuestionRepository.watchAll())
            .thenReturn(Result.ok(stream));

        final result = useCase.execute();

        expect(result.isOk, isTrue);
        expect(result.ok, stream);
      },
    );
  });
}

class DummyQuestionRepository extends Mock implements QuestionRepository {}
