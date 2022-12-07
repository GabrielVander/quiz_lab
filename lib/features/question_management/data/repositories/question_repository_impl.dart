import 'package:okay/okay.dart';

import '../../../../core/utils/unit.dart';
import '../../domain/entities/question.dart';
import '../../domain/repositories/question_repository.dart';
import '../data_sources/firebase_data_source.dart';
import '../data_sources/hive_data_source.dart';
import '../data_sources/models/question_model.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  const QuestionRepositoryImpl({
    required FirebaseDataSource firebaseDataSource,
    required HiveDataSource hiveDataSource,
  })  : _hiveDataSource = hiveDataSource,
        _firebaseDataSource = firebaseDataSource;

  final FirebaseDataSource _firebaseDataSource;
  final HiveDataSource _hiveDataSource;

  @override
  Future<Result<Stream<Question>, QuestionRepositoryFailure>> watchAll() async {
    final localQuestionsResult = await _hiveDataSource.watchAllQuestions();

    if (localQuestionsResult.isErr) {
      return Result.err(
        QuestionRepositoryLibraryFailure(
          message: 'Unable to watch questions: '
              '${(localQuestionsResult.err!).message}',
        ),
      );
    }

    return Result.ok(
      Stream<Question>.fromIterable(
        await localQuestionsResult.ok!
            .map((model) => model.toEntity())
            .toList(),
      ),
    );
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> deleteSingle(
    String id,
  ) async {
    final deletionResult = await _hiveDataSource.deleteQuestion(
      QuestionModel(
        id: id,
        shortDescription: 'shortDescription',
        description: 'description',
        difficulty: 'difficulty',
        categories: const [],
      ),
    );

    return deletionResult.mapErr(
      (error) => _mapHiveFailure(id, error),
    );
  }

  QuestionRepositoryInvalidQuestionFailure _mapHiveFailure(
    String id,
    HiveDataSourceFailure error,
  ) {
    switch (error.runtimeType) {
      case HiveDataSourceInvalidIdFailure:
        return QuestionRepositoryInvalidQuestionFailure(
          message: 'Unable to delete question with id $id: '
              '${(error as HiveDataSourceInvalidIdFailure).message}',
        );
      default:
        return const QuestionRepositoryInvalidQuestionFailure(message: '');
    }
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> createSingle(
    Question question,
  ) async {
    await _firebaseDataSource
        .createPublicQuestion(QuestionModel.fromEntity(question));

    return const Result.ok(unit);
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> updateSingle(
    Question question,
  ) async {
    await _firebaseDataSource
        .updateQuestion(QuestionModel.fromEntity(question));

    return const Result.ok(unit);
  }
}
