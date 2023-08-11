import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/draft_question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';

void main() {
  late QuizLabLogger logger;
  late ResourceUuidGenerator uuidGenerator;
  late QuestionRepository questionRepository;
  late CreateQuestionUseCase useCase;

  setUp(() {
    logger = _MockQuizLabLogger();
    uuidGenerator = _MockResourceUuidGenerator();
    questionRepository = _MockQuestionRepository();

    useCase = CreateQuestionUseCaseImpl(
      logger: logger,
      questionRepository: questionRepository,
      uuidGenerator: uuidGenerator,
    );
  });

  tearDown(resetMocktailState);

  test('should log initial message', () {
    useCase.call(
      const DraftQuestion(
        title: '',
        description: '',
        difficulty: '',
        options: [],
        categories: [],
      ),
    );

    verify(() => logger.info('Executing...')).called(1);
  });

  group(
    'when given unparsable difficulty',
    () {
      for (final values in [
        (
          const DraftQuestion(
            title: '',
            description: '',
            difficulty: '',
            options: [],
            categories: [],
          ),
          "Unable to create question: Received unparseable difficulty ''",
        ),
        (
          const DraftQuestion(
            title: '3Yd0',
            description: 'f19!t',
            difficulty: '8Fy',
            options: [],
            categories: [
              QuestionCategory(value: 'Du0QQGO'),
              QuestionCategory(value: 'O95eCUO')
            ],
          ),
          "Unable to create question: Received unparseable difficulty '8Fy'",
        )
      ]) {
        final draft = values.$1;
        final expectedMessage = values.$2;

        test('should fail with $expectedMessage', () async {
          final result = await useCase(draft);

          expect(result, Err<Unit, String>(expectedMessage));
        });
      }
    },
  );

  for (final values in [
    (
      const DraftQuestion(
        title: '',
        description: '',
        difficulty: 'medium',
        options: [],
        categories: [],
      ),
      '',
      '8&tL6xjE',
      const Question(
        id: QuestionId(''),
        shortDescription: '',
        description: '',
        answerOptions: [],
        difficulty: QuestionDifficulty.medium,
        categories: [],
      )
    ),
    (
      const DraftQuestion(
        title: 'title',
        description: 'description',
        difficulty: 'easy',
        options: [
          AnswerOption(
            description: 'description',
            isCorrect: false,
          )
        ],
        categories: [QuestionCategory(value: 'category')],
        isPublic: true,
      ),
      'uuid',
      'zVW7N',
      const Question(
        id: QuestionId('uuid'),
        shortDescription: 'title',
        description: 'description',
        answerOptions: [
          AnswerOption(
            description: 'description',
            isCorrect: false,
          )
        ],
        difficulty: QuestionDifficulty.easy,
        categories: [QuestionCategory(value: 'category')],
        isPublic: true,
      )
    ),
    (
      const DraftQuestion(
        title: '336dhR',
        description: '91A^*#Z',
        difficulty: 'hard',
        options: [
          AnswerOption(
            description: '3W55p',
            isCorrect: false,
          ),
          AnswerOption(
            description: 'n&!MLH1',
            isCorrect: true,
          ),
        ],
        categories: [
          QuestionCategory(value: 'y6q729L'),
          QuestionCategory(value: '3^*#Z')
        ],
      ),
      'pvx',
      '4p&',
      const Question(
        id: QuestionId('pvx'),
        shortDescription: '336dhR',
        description: '91A^*#Z',
        difficulty: QuestionDifficulty.hard,
        answerOptions: [
          AnswerOption(
            description: '3W55p',
            isCorrect: false,
          ),
          AnswerOption(
            description: 'n&!MLH1',
            isCorrect: true,
          ),
        ],
        categories: [
          QuestionCategory(value: 'y6q729L'),
          QuestionCategory(value: '3^*#Z')
        ],
      )
    ),
  ]) {
    final draft = values.$1;
    final uuid = values.$2;
    final repositoryFailure = values.$3;
    final expectedQuestion = values.$4;

    group('should return failure when questions repository fails with', () {
      setUp(() => registerFallbackValue(_MockQuestion()));

      test(repositoryFailure, () async {
        when(() => uuidGenerator.generate()).thenReturn(uuid);
        when(() => questionRepository.createSingle(any()))
            .thenAnswer((_) async => Err(repositoryFailure));

        final result = await useCase(draft);

        verify(() => questionRepository.createSingle(expectedQuestion));
        verify(() => logger.error(repositoryFailure)).called(1);
        expect(
          result,
          const Err<Unit, String>('Unable to create question'),
        );
      });
    });

    test('should return ok if questions repository succeeds', () async {
      when(() => uuidGenerator.generate()).thenReturn(uuid);
      when(() => questionRepository.createSingle(expectedQuestion))
          .thenAnswer((_) async => const Ok(unit));

      final result = await useCase(draft);

      verify(() => logger.info('Question created successfully')).called(1);
      expect(result, const Ok<Unit, String>(unit));
    });
  }
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockQuestionRepository extends Mock implements QuestionRepository {}

class _MockResourceUuidGenerator extends Mock
    implements ResourceUuidGenerator {}

class _MockQuestion extends Mock implements Question {}
