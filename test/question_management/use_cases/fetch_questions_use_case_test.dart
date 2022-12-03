import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/fetch_questions_use_case.dart';

void main() {
  late QuestionRepository dummyQuestionRepository;
  late WatchAllQuestionsUseCase useCase;

  setUp(() {
    dummyQuestionRepository = DummyQuestionRepository();
    useCase =
        WatchAllQuestionsUseCase(questionRepository: dummyQuestionRepository);
  });

  tearDown(resetMocktailState);

  test('Use case should use repository correctly', () {
    when(() => dummyQuestionRepository.watchAll())
        .thenAnswer((_) => const Stream<List<Question>>.empty());

    useCase.execute();

    verify(() => dummyQuestionRepository.watchAll()).called(1);
  });

  group('Use case should return stream from repository', () {
    for (final stream in [
      const Stream<List<Question>>.empty(),
      Stream<List<Question>>.fromIterable([]),
      Stream<List<Question>>.fromIterable([
        [
          const Question(
            id: '15e194a8-8fa9-4b04-af8f-8d71491ac7e8',
            shortDescription: 'shortDescription',
            description: 'description',
            answerOptions: [],
            difficulty: QuestionDifficulty.hard,
            categories: [],
          ),
        ]
      ]),
      Stream<List<Question>>.fromIterable([
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
      ]),
    ]) {
      test(stream, () {
        when(() => dummyQuestionRepository.watchAll())
            .thenAnswer((_) => stream);

        final result = useCase.execute();

        expect(result, stream);
      });
    }
  });
}

class DummyQuestionRepository extends Mock implements QuestionRepository {}
