import 'package:okay/okay.dart';

import '../../../../core/utils/unit.dart';
import '../../domain/entities/question.dart';
import '../../domain/repositories/question_repository.dart';
import '../data_sources/firebase_data_source.dart';
import '../data_sources/hive_data_source.dart';
import '../data_sources/mappers/hive_question_model_mapper.dart';
import '../data_sources/models/hive_question_model.dart';
import 'mappers/question_mapper.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  const QuestionRepositoryImpl({
    required FirebaseDataSource firebaseDataSource,
    required HiveDataSource hiveDataSource,
    required QuestionMapper questionMapper,
    required HiveQuestionModelMapper hiveQuestionModelMapper,
  })  : _hiveDataSource = hiveDataSource,
        _firebaseDataSource = firebaseDataSource,
        _questionMapper = questionMapper,
        _hiveQuestionModelMapper = hiveQuestionModelMapper;

  final FirebaseDataSource _firebaseDataSource;
  final HiveDataSource _hiveDataSource;
  final QuestionMapper _questionMapper;
  final HiveQuestionModelMapper _hiveQuestionModelMapper;

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> createSingle(
    Question question,
  ) async {
    final mappingResult = _hiveQuestionModelMapper.fromQuestion(question);

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
    final mappingResult = _hiveQuestionModelMapper.fromQuestion(question);

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
