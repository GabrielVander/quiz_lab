import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/factories/data_source_factory.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/hive_question_model.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/hive_question_model_mapper.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/question_entity_mapper.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  const QuestionRepositoryImpl({
    required DataSourceFactory dataSourceFactory,
    required QuestionEntityMapper questionMapper,
    required HiveQuestionModelMapper hiveQuestionModelMapper,
  })  : _dataSourceFactory = dataSourceFactory,
        _questionMapper = questionMapper,
        _hiveQuestionModelMapper = hiveQuestionModelMapper;

  final QuestionEntityMapper _questionMapper;
  final HiveQuestionModelMapper _hiveQuestionModelMapper;
  final DataSourceFactory _dataSourceFactory;

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> createSingle(
    Question question,
  ) async {
    final hiveDataSource = _dataSourceFactory.makeHiveDataSource();
    final hiveModel = _hiveQuestionModelMapper.fromQuestion(question);
    final creationResult = await hiveDataSource.saveQuestion(hiveModel);

    if (creationResult.isErr) {
      return Result.err(
        QuestionRepositoryFailure.unableToCreate(
          question: question,
          message: creationResult.err!.message,
        ),
      );
    }

    return const Result.ok(unit);
  }

  @override
  Result<Stream<List<Question>>, QuestionRepositoryFailure> watchAll() {
    final hiveDataSource = _dataSourceFactory.makeHiveDataSource();
    final localQuestionsResult = hiveDataSource.watchAllQuestions();

    if (localQuestionsResult.isErr) {
      return Result.err(
        QuestionRepositoryFailure.unableToWatchAll(
          message: (localQuestionsResult.err!).message,
        ),
      );
    }

    return Result.ok(_parseToEntityStream(localQuestionsResult.ok!));
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> updateSingle(
    Question question,
  ) async {
    final hiveDataSource = _dataSourceFactory.makeHiveDataSource();
    final hiveModel = _hiveQuestionModelMapper.fromQuestion(question);
    final updateResult = await hiveDataSource.saveQuestion(hiveModel);

    if (updateResult.isErr) {
      return Result.err(
        QuestionRepositoryFailure.unableToUpdate(
          id: question.id,
          details: updateResult.err!.message,
        ),
      );
    }

    return const Result.ok(unit);
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> deleteSingle(
    String id,
  ) async {
    final hiveDataSource = _dataSourceFactory.makeHiveDataSource();
    final deletionResult = await hiveDataSource.deleteQuestion(
      HiveQuestionModel(
        id: id,
        shortDescription: null,
        description: null,
        difficulty: null,
        categories: null,
      ),
    );

    return deletionResult.mapErr(
      (error) => QuestionRepositoryFailure.unableToDelete(id: id),
    );
  }

  Stream<List<Question>> _parseToEntityStream(
    Stream<List<HiveQuestionModel>> stream,
  ) {
    return stream.map(
      (m) => m
          .map(_questionMapper.fromHiveModel)
          .where((result) => result.isOk)
          .map((result) => result.ok!)
          .toList(),
    );
  }
}
