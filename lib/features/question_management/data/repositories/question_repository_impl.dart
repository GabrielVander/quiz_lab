import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/hive_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/mappers/hive_question_model_mapper.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/hive_question_model.dart';
import 'package:quiz_lab/features/question_management/data/repositories/mappers/question_mapper.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  const QuestionRepositoryImpl({
    required HiveDataSource hiveDataSource,
    required QuestionMapper questionMapper,
    required HiveQuestionModelMapper hiveQuestionModelMapper,
  })  : _hiveDataSource = hiveDataSource,
        _questionMapper = questionMapper,
        _hiveQuestionModelMapper = hiveQuestionModelMapper;

  final HiveDataSource _hiveDataSource;
  final QuestionMapper _questionMapper;
  final HiveQuestionModelMapper _hiveQuestionModelMapper;

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> createSingle(
    Question question,
  ) async {
    final hiveModel = _hiveQuestionModelMapper.fromQuestion(question);
    final creationResult = await _hiveDataSource.saveQuestion(hiveModel);

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
    final localQuestionsResult = _hiveDataSource.watchAllQuestions();

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
    final hiveModel = _hiveQuestionModelMapper.fromQuestion(question);
    final updateResult = await _hiveDataSource.saveQuestion(hiveModel);

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
    final deletionResult = await _hiveDataSource.deleteQuestion(
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
