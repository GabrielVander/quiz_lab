import 'package:okay/okay.dart';

import '../../../../core/utils/unit.dart';
import '../../domain/entities/question.dart';
import '../../domain/repositories/question_repository.dart';
import '../data_sources/firebase_data_source.dart';
import '../data_sources/hive_data_source.dart';
import '../data_sources/models/question_model.dart';
import '../mappers/question_mapper.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  const QuestionRepositoryImpl({
    required FirebaseDataSource firebaseDataSource,
    required HiveDataSource hiveDataSource,
    required QuestionMapper questionMapper,
  })  : _hiveDataSource = hiveDataSource,
        _firebaseDataSource = firebaseDataSource,
        _questionMapper = questionMapper;

  final FirebaseDataSource _firebaseDataSource;
  final HiveDataSource _hiveDataSource;
  final QuestionMapper _questionMapper;

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> createSingle(
    Question question,
  ) async {
    final mappingResult = _questionMapper.mapEntityToHiveModel(question);

    if (mappingResult.isErr) {
      return Result.err(
        QuestionRepositoryFailure.unableToParseEntity(
          message: mappingResult.err!.message,
        ),
      );
    }

    final creationResult = await _hiveDataSource.saveQuestion(
      mappingResult.ok!,
    );

    if (creationResult.isErr) {
      return Result.err(
        QuestionRepositoryFailure.unableToCreate(question: question),
      );
    }

    return const Result.ok(unit);
  }

  @override
  Future<Result<Stream<Question>, QuestionRepositoryFailure>> watchAll() async {
    final localQuestionsResult = await _hiveDataSource.watchAllQuestions();

    if (localQuestionsResult.isErr) {
      return Result.err(
        QuestionRepositoryFailure.unableToWatchAll(
          message: (localQuestionsResult.err!).message,
        ),
      );
    }

    try {
      return Result.ok(await _parseToEntityStream(localQuestionsResult));
    } on _ParseException catch (e) {
      return Result.err(
        QuestionRepositoryFailure.unableToWatchAll(message: e.message),
      );
    }
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> updateSingle(
    Question question,
  ) async {
    final mappingResult = _questionMapper.mapEntityToHiveModel(question);

    if (mappingResult.isErr) {
      return Result.err(
        QuestionRepositoryFailure.unableToParseEntity(
          message: mappingResult.err!.message,
        ),
      );
    }

    final updateResult = await _hiveDataSource.saveQuestion(mappingResult.ok!);

    if (updateResult.isErr) {
      return Result.err(
        QuestionRepositoryFailure.unableToUpdate(question: question),
      );
    }

    return const Result.ok(unit);
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> deleteSingle(
    String id,
  ) async {
    final deletionResult = await _hiveDataSource.deleteQuestion(
      // TODO: All HiveQuestionModel fields should be nullable
      HiveQuestionModel(
        id: id,
        shortDescription: 'shortDescription',
        description: 'description',
        difficulty: 'difficulty',
        categories: const [],
      ),
    );

    return deletionResult.mapErr(
      (error) => QuestionRepositoryFailure.unableToDelete(id: id),
    );
  }

  Future<Stream<Question>> _parseToEntityStream(
    Result<Stream<HiveQuestionModel>, HiveDataSourceFailure>
        localQuestionsResult,
  ) async {
    return Stream.fromIterable(
      await localQuestionsResult.ok!
          .map(_questionMapper.mapHiveModelToEntity)
          .map(
            (mapperResult) => mapperResult.when(
              ok: (question) => question,
              err: (failure) => throw _ParseException(message: failure.message),
            ),
          )
          .toList(),
    );
  }
}

class _ParseException implements Exception {
  const _ParseException({
    required this.message,
  });

  final String message;
}
