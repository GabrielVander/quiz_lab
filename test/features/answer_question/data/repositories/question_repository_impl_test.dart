import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/common/data/dto/appwrite_question_dto.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/features/answer_question/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/answer_question/domain/entities/answerable_question.dart' as answerable_question;
import 'package:quiz_lab/features/answer_question/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_question_option_dto.dart';

void main() {
  late QuizLabLogger logger;
  late QuestionCollectionAppwriteDataSource questionCollectionAppwriteDataSource;
  late ResourceUuidGenerator uuidGenerator;

  late QuestionRepository repository;

  setUp(() {
    logger = _MockQuizLabLogger();
    questionCollectionAppwriteDataSource = _MockQuestionsAppwriteDataSource();
    uuidGenerator = _MockUuidGenerator();

    repository = QuestionRepositoryImpl(
      logger: logger,
      questionsAppwriteDataSource: questionCollectionAppwriteDataSource,
      uuidGenerator: uuidGenerator,
    );
  });

  tearDown(resetMocktailState);

  group('fetchQuestionWithId', () {
    test('should log initial message', () {
      when(() => questionCollectionAppwriteDataSource.fetchSingle(any()))
          .thenAnswer((_) async => Err(QuestionsAppwriteDataSourceUnexpectedFailure('22!4RhY8')));

      repository.fetchQuestionWithId(r'2I2SE$');

      verify(() => logger.debug('Fetching question with given id...'));
    });

    group('should return Err if question appwrite collection data source fails', () {
      for (final testCase in [
        ('9ha', QuestionsAppwriteDataSourceUnexpectedFailure(r'JlBm$8W')),
        (r'q$49', QuestionsAppwriteDataSourceUnexpectedFailure('95#')),
      ]) {
        final id = testCase.$1;
        final QuestionsAppwriteDataSourceFailure failure = testCase.$2;

        test('with $id as id and $failure as failure', () async {
          when(() => questionCollectionAppwriteDataSource.fetchSingle(any())).thenAnswer((_) async => Err(failure));

          final result = await repository.fetchQuestionWithId(id);

          verify(() => questionCollectionAppwriteDataSource.fetchSingle(id)).called(1);
          verify(() => logger.error(failure.toString())).called(1);
          expect(result, const Err<dynamic, String>('Unable to fetch question with given id'));
        });
      }
    });

    group('should return Ok with expected question', () {
      for (final testCase in [
        (
          'gqQp',
          const AppwriteQuestionDto(
            id: 'k2Kao43',
            title: 'v5l!@',
            options: [
              AppwriteQuestionOptionDto(
                description: '7T5Tm0p',
                isCorrect: false,
              ),
              AppwriteQuestionOptionDto(
                description: '!D@g3',
                isCorrect: true,
              ),
              AppwriteQuestionOptionDto(
                description: 'V%#BGZ',
                isCorrect: false,
              ),
            ],
            difficulty: 'Tw&N9dD',
            description: 'JLzh',
            categories: ['p4lM', r'#2$vxpA', 'cWnH2io'],
            databaseId: 'Cxc#Y1Cj',
            collectionId: 'h^NjK84I',
            createdAt: '516',
            updatedAt: 'D3y^k#Hw',
            profile: 'OX8BLEUE',
          ),
          'h%xqs',
          const answerable_question.AnswerableQuestion(
            id: 'k2Kao43',
            title: 'v5l!@',
            description: 'JLzh',
            answers: [
              answerable_question.Answer(
                id: 'h%xqs',
                description: '7T5Tm0p',
                isCorrect: false,
              ),
              answerable_question.Answer(
                id: 'h%xqs',
                description: '!D@g3',
                isCorrect: true,
              ),
              answerable_question.Answer(
                id: 'h%xqs',
                description: 'V%#BGZ',
                isCorrect: false,
              ),
            ],
            difficulty: QuestionDifficulty.unknown,
          )
        ),
        (
          'UiSw#b6B',
          const AppwriteQuestionDto(
            id: 'ber%4p',
            title: '0d%6QqT',
            options: [
              AppwriteQuestionOptionDto(
                description: '3d^IL1',
                isCorrect: true,
              ),
              AppwriteQuestionOptionDto(
                description: '6KptEM2X',
                isCorrect: false,
              ),
              AppwriteQuestionOptionDto(
                description: 'b^jDbq',
                isCorrect: true,
              ),
            ],
            difficulty: 'medium',
            description: 'JLzh',
            categories: ['p4lM', r'#2$vxpA', 'cWnH2io'],
            databaseId: 'Cxc#Y1Cj',
            collectionId: 'h^NjK84I',
            createdAt: '516',
            updatedAt: 'D3y^k#Hw',
            profile: 'OX8BLEUE',
          ),
          'h%xqs',
          const answerable_question.AnswerableQuestion(
            id: 'ber%4p',
            title: '0d%6QqT',
            description: 'JLzh',
            answers: [
              answerable_question.Answer(
                id: 'h%xqs',
                description: '3d^IL1',
                isCorrect: true,
              ),
              answerable_question.Answer(
                id: 'h%xqs',
                description: '6KptEM2X',
                isCorrect: false,
              ),
              answerable_question.Answer(
                id: 'h%xqs',
                description: 'b^jDbq',
                isCorrect: true,
              ),
            ],
            difficulty: QuestionDifficulty.medium,
          )
        ),
      ]) {
        final id = testCase.$1;
        final appwriteQuestionDto = testCase.$2;
        final generatedUuid = testCase.$3;
        final expected = testCase.$4;

        test('with $id as id, $appwriteQuestionDto as dto and $expected as expected question', () async {
          when(() => questionCollectionAppwriteDataSource.fetchSingle(any()))
              .thenAnswer((_) async => Ok(appwriteQuestionDto));
          when(() => uuidGenerator.generate()).thenReturn(generatedUuid);

          final result = await repository.fetchQuestionWithId(id);

          verify(() => questionCollectionAppwriteDataSource.fetchSingle(id)).called(1);
          verify(() => logger.debug('Question fetched successfully')).called(1);
          expect(result, Ok<answerable_question.AnswerableQuestion, dynamic>(expected));
        });
      }
    });
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockQuestionsAppwriteDataSource extends Mock implements QuestionCollectionAppwriteDataSourceImpl {}

class _MockUuidGenerator extends Mock implements ResourceUuidGenerator {}
