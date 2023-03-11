import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_creation_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_option_model.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class QuestionRepositoryAppwriteImpl extends QuestionRepository {
  QuestionRepositoryAppwriteImpl({
    required AppwriteDataSource appwriteDataSource,
  }) : _appwriteDataSource = appwriteDataSource;
  final _logger = QuizLabLoggerFactory.createLogger<AppwriteDataSource>();

  final AppwriteDataSource _appwriteDataSource;

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> createSingle(
    Question question,
  ) async {
    _logger.debug('Creating question...');

    await _appwriteDataSource.createQuestion(
      AppwriteQuestionCreationModel(
        id: question.id,
        title: question.shortDescription,
        description: question.description,
        options: question.answerOptions
            .map(
              (e) => AppwriteQuestionOptionModel(
                description: e.description,
                isCorrect: e.isCorrect,
              ),
            )
            .toList(),
        difficulty: question.difficulty.name,
        categories: question.categories.map((e) => e.value).toList(),
      ),
    );

    return const Result.ok(unit);
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> deleteSingle(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> updateSingle(
    Question question,
  ) {
    throw UnimplementedError();
  }

  @override
  Result<Stream<List<Question>>, QuestionRepositoryFailure> watchAll() {
    throw UnimplementedError();
  }
}
