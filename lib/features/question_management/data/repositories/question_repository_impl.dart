import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/factories/data_source_factory.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/hive_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/hive_question_model.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/factories/mapper_factory.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  const QuestionRepositoryImpl({
    required DataSourceFactory dataSourceFactory,
    required MapperFactory mapperFactory,
  })  : _mapperFactory = mapperFactory,
        _dataSourceFactory = dataSourceFactory;

  final DataSourceFactory _dataSourceFactory;
  final MapperFactory _mapperFactory;

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> createSingle(
    Question question,
  ) async {
    final hiveModel = _hiveQuestionModelToQuestion(question);
    final savingResult = await _saveModelToHive(hiveModel);

    if (savingResult.isErr) {
      return Result.err(
        QuestionRepositoryFailure.unableToCreate(
          question: question,
          message: savingResult.err!.message,
        ),
      );
    }

    return const Result.ok(unit);
  }

  @override
  Future<Result<Stream<List<Question>>, QuestionRepositoryFailure>>
      watchAll() async {
    final hiveQuestionsResult = _watchHiveQuestions();

    if (hiveQuestionsResult.isErr) {
      return Result.err(
        QuestionRepositoryFailure.unableToWatchAll(
          message: (hiveQuestionsResult.err!).message,
        ),
      );
    }

    return Result.ok(_parseToEntityStream(hiveQuestionsResult.ok!));
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> updateSingle(
    Question question,
  ) async {
    final hiveModel = _hiveQuestionModelToQuestion(question);
    final savingResult = await _saveModelToHive(hiveModel);

    if (savingResult.isErr) {
      return Result.err(
        QuestionRepositoryFailure.unableToUpdate(
          id: question.id,
          details: savingResult.err!.message,
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
        options: null,
      ),
    );

    return deletionResult.mapErr(
      (error) => QuestionRepositoryFailure.unableToDelete(id: id),
    );
  }

  HiveQuestionModel _hiveQuestionModelToQuestion(Question question) {
    final hiveQuestionModelMapper =
        _mapperFactory.makeHiveQuestionModelMapper();
    final hiveModel = hiveQuestionModelMapper.fromQuestion(question);

    return hiveModel;
  }

  Future<Result<Unit, HiveDataSourceFailure>> _saveModelToHive(
    HiveQuestionModel hiveModel,
  ) async {
    final hiveDataSource = _dataSourceFactory.makeHiveDataSource();
    final savingResult = await hiveDataSource.saveQuestion(hiveModel);

    return savingResult;
  }

  Result<Stream<List<HiveQuestionModel>>, HiveDataSourceFailure>
      _watchHiveQuestions() {
    final hiveDataSource = _dataSourceFactory.makeHiveDataSource();
    final hiveQuestionsResult = hiveDataSource.watchAllQuestions();

    return hiveQuestionsResult;
  }

  Stream<List<Question>> _parseToEntityStream(
    Stream<List<HiveQuestionModel>> stream,
  ) {
    final questionEntityMapper = _mapperFactory.makeQuestionEntityMapper();

    return stream.map(
      (m) => m
          .map(questionEntityMapper.fromHiveModel)
          .where((result) => result.isOk)
          .map((result) => result.ok!)
          .toList(),
    );
  }
}
