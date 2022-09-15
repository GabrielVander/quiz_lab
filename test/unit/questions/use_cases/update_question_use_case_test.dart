import 'package:flutter_parameterized_test/flutter_parameterized_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/features/quiz/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_category.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/quiz/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/quiz/domain/use_cases/update_question_use_case.dart';

void main() {
  late QuestionRepository dummyRepository;
  late UpdateQuestionUseCase useCase;

  setUp(() {
    dummyRepository = MockQuestionRepository();
    useCase = UpdateQuestionUseCase(questionRepository: dummyRepository);
  });

  tearDown(resetMocktailState);

  parameterizedTest(
    'Should delegate to repository',
    ParameterizedSource.value([
      const Question(
        id: '',
        shortDescription: '',
        description: '',
        categories: [],
        difficulty: QuestionDifficulty.unknown,
        answerOptions: [],
      ),
      const Question(
        id: 'a019cc50-db0b-42e2-895a-ac5a37a79faa',
        shortDescription: 'hunger',
        description: 'Nuptias ire, tanquam superbus hippotoxota.',
        categories: [
          QuestionCategory(value: 'sail'),
          QuestionCategory(value: 'pen'),
          QuestionCategory(value: 'station'),
        ],
        difficulty: QuestionDifficulty.hard,
        answerOptions: [
          AnswerOption(description: 'fort charles ', isCorrect: false),
          AnswerOption(description: 'yardarm ', isCorrect: true),
          AnswerOption(description: 'fortune ', isCorrect: false),
        ],
      )
    ]),
    (values) async {
      final input = values[0] as Question;

      when(() => dummyRepository.updateSingle(input)).thenAnswer((_) async {});

      await useCase.execute(input);

      verify(() => dummyRepository.updateSingle(input)).called(1);
    },
  );
}

class MockQuestionRepository extends Mock implements QuestionRepository {}
