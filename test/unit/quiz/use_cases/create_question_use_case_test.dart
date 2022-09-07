import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_category.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/quiz/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/quiz/domain/use_cases/create_question_use_case.dart';

void main() {
  late QuestionRepository dummyRepository;
  late CreateQuestionUseCase useCase;

  setUp(() {
    dummyRepository = DummyQuestionRepository();
    useCase = CreateQuestionUseCase(questionRepository: dummyRepository);
  });

  tearDown(resetMocktailState);

  group('Should call repository correctly', () {
    setUpAll(() {
      registerFallbackValue(FakeQuestion());
    });

    for (final testCase in [
      [
        const QuestionCreationInput(
          shortDescription: 'shortDescription',
          description: 'description',
          difficulty: QuestionDifficultyInput.easy,
          categories: QuestionCategoryInput(values: []),
        ),
        const Question(
          shortDescription: 'shortDescription',
          description: 'description',
          answerOptions: [],
          difficulty: QuestionDifficulty.easy,
          categories: [],
        )
      ],
      [
        const QuestionCreationInput(
          shortDescription: 'nkl!',
          description: 'oaK',
          difficulty: QuestionDifficultyInput.medium,
          categories: QuestionCategoryInput(values: ['3@0lv*ip', '@1H7']),
        ),
        const Question(
          shortDescription: 'nkl!',
          description: 'oaK',
          answerOptions: [],
          difficulty: QuestionDifficulty.medium,
          categories: [
            QuestionCategory(value: '3@0lv*ip'),
            QuestionCategory(value: '@1H7')
          ],
        )
      ],
    ]) {
      final input = testCase[0] as QuestionCreationInput;
      final expected = testCase[1] as Question;

      test('$input -> $expected', () async {
        when(() => dummyRepository.createSingle(any()))
            .thenAnswer((_) async {});

        await useCase.execute(input);

        verify(() => dummyRepository.createSingle(expected)).called(1);
      });
    }
  });
}

class FakeQuestion extends Fake implements Question {}

class DummyQuestionRepository extends Mock implements QuestionRepository {}
