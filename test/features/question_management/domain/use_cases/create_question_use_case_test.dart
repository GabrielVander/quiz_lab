import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/draft_question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
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
    );

    registerFallbackValue(_MockDraftQuestion());
  });

  tearDown(resetMocktailState);

  test('should log initial message', () {
    when(() => uuidGenerator.generate()).thenReturn('8&tL6xjE');
    when(() => questionRepository.createSingle(any())).thenAnswer((_) async => const Err('9qNsuf'));

    useCase.call(
      const DraftQuestion(
        title: '',
        description: '',
        difficulty: QuestionDifficulty.unknown,
        options: [],
        categories: [],
      ),
    );

    verify(() => logger.info('Executing...')).called(1);
  });

  for (final values in [
    (
      const DraftQuestion(
        title: '',
        description: '',
        difficulty: QuestionDifficulty.medium,
        options: [],
        categories: [],
      ),
      '',
      '8&tL6xjE',
    ),
    (
      const DraftQuestion(
        title: 'title',
        description: 'description',
        difficulty: QuestionDifficulty.easy,
        options: [
          AnswerOption(
            description: 'description',
            isCorrect: false,
          ),
        ],
        categories: [QuestionCategory(value: 'category')],
        isPublic: true,
      ),
      'uuid',
      'zVW7N',
    ),
    (
      const DraftQuestion(
        title: '336dhR',
        description: '91A^*#Z',
        difficulty: QuestionDifficulty.hard,
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
        categories: [QuestionCategory(value: 'y6q729L'), QuestionCategory(value: '3^*#Z')],
      ),
      'pvx',
      '4p&',
    ),
  ]) {
    final draft = values.$1;
    final uuid = values.$2;
    final repositoryFailure = values.$3;

    group('should return failure when questions repository fails with', () {
      setUp(() => registerFallbackValue(_MockQuestion()));

      test(repositoryFailure, () async {
        when(() => questionRepository.createSingle(draft)).thenAnswer((_) async => Err(repositoryFailure));

        final result = await useCase(draft);

        verify(() => logger.error(repositoryFailure)).called(1);
        expect(result, const Err<Unit, String>('Unable to create question'));
      });
    });

    test('should return ok if questions repository succeeds', () async {
      when(() => uuidGenerator.generate()).thenReturn(uuid);
      when(() => questionRepository.createSingle(draft)).thenAnswer((_) async => const Ok(unit));

      final result = await useCase(draft);

      verify(() => logger.info('Question created successfully')).called(1);
      expect(result, const Ok<Unit, String>(unit));
    });
  }
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockQuestionRepository extends Mock implements QuestionRepository {}

class _MockResourceUuidGenerator extends Mock implements ResourceUuidGenerator {}

class _MockQuestion extends Mock implements Question {}

class _MockDraftQuestion extends Mock implements DraftQuestion {}
