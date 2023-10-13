import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/common/data/dto/appwrite_question_dto.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/answer_question/data/repositories/question_repository_impl.dart';
import 'package:quiz_lab/features/answer_question/domain/repositories/question_repository.dart';

void main() {
  late QuizLabLogger logger;
  late QuestionCollectionAppwriteDataSource questionCollectionAppwriteDataSource;

  late QuestionRepository repository;

  setUp(() {
    logger = _MockQuizLabLogger();
    questionCollectionAppwriteDataSource = _MockQuestionsAppwriteDataSource();

    repository = QuestionRepositoryImpl(
      logger: logger,
      questionsAppwriteDataSource: questionCollectionAppwriteDataSource,
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
      for (final id in ['gqQp', 'gIEqXw']) {
        test('with $id as id', () async {
          final appwriteQuestionDto = _MockAppwriteQuestionDto();
          final expected = _MockQuestion();

          when(() => questionCollectionAppwriteDataSource.fetchSingle(any()))
              .thenAnswer((_) async => Ok(appwriteQuestionDto));
          when(appwriteQuestionDto.toQuestion).thenReturn(expected);

          final result = await repository.fetchQuestionWithId(id);

          verify(() => questionCollectionAppwriteDataSource.fetchSingle(id)).called(1);
          verify(() => logger.debug('Question fetched successfully')).called(1);
          verify(appwriteQuestionDto.toQuestion).called(1);
          expect(result, Ok<Question, String>(expected));
        });
      }
    });
  });
}

class _MockQuizLabLogger extends Mock implements QuizLabLogger {}

class _MockQuestionsAppwriteDataSource extends Mock implements QuestionCollectionAppwriteDataSourceImpl {}

class _MockAppwriteQuestionDto extends Mock implements AppwriteQuestionDto {}

class _MockQuestion extends Mock implements Question {}
