import 'dart:async';

import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_permission_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_option_model.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_creation_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class QuestionRepositoryImpl extends QuestionRepository {
  QuestionRepositoryImpl({
    required AppwriteDataSource appwriteDataSource,
    required QuestionCollectionAppwriteDataSource questionsAppwriteDataSource,
  })  : _appwriteDataSource = appwriteDataSource,
        _questionsAppwriteDataSource = questionsAppwriteDataSource;

  final _logger = QuizLabLoggerFactory.createLogger<QuestionRepositoryImpl>();

  final AppwriteDataSource _appwriteDataSource;
  final QuestionCollectionAppwriteDataSource _questionsAppwriteDataSource;

  final _questionsStreamController = StreamController<List<Question>>();

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> createSingle(
    Question question,
  ) async {
    _logger.debug('Creating question...');

    await _questionsAppwriteDataSource.createSingle(
      AppwriteQuestionCreationModel(
        id: question.id.value,
        title: question.shortDescription,
        description: question.description,
        options: question.answerOptions
            .map(
              (o) => AppwriteQuestionOptionModel(
                description: o.description,
                isCorrect: o.isCorrect,
              ),
            )
            .toList(),
        difficulty: question.difficulty.name,
        categories: question.categories.map((e) => e.value).toList(),
        permissions: question.isPublic
            ? [
                AppwritePermissionTypeModel.read(
                  AppwritePermissionRoleModel.any(),
                )
              ]
            : null,
      ),
    );

    return const Ok(unit);
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> deleteSingle(
    QuestionId id,
  ) async {
    _logger.debug('Deleting question...');

    final deletionResult =
        await _questionsAppwriteDataSource.deleteSingle(id.value);

    return deletionResult.when(
      ok: (_) {
        _logger.debug('Question deleted successfully');
        return const Ok(unit);
      },
      err: (failure) => Err(_mapQuestionsAppwriteDataSourceFailure(failure)),
    );
  }

  @override
  Future<Result<Question, QuestionRepositoryFailure>> getSingle(
    QuestionId id,
  ) async {
    _logger.debug('Getting question...');

    final fetchResult =
        await _questionsAppwriteDataSource.fetchSingle(id.value);

    return fetchResult.when(
      ok: (model) {
        _logger.debug('Question fetched successfully');
        return Ok(model.toQuestion());
      },
      err: (failure) => Err(_mapQuestionsAppwriteDataSourceFailure(failure)),
    );
  }

  QuestionRepositoryFailure _mapQuestionsAppwriteDataSourceFailure(
    QuestionsAppwriteDataSourceFailure dataSourceFailure,
  ) {
    QuestionRepositoryFailure repoFailure = QuestionRepositoryUnexpectedFailure(
      message: dataSourceFailure.toString(),
    );

    switch (dataSourceFailure.runtimeType) {
      case QuestionsAppwriteDataSourceUnexpectedFailure:
        repoFailure = QuestionRepositoryUnexpectedFailure(
          message: (dataSourceFailure
                  as QuestionsAppwriteDataSourceUnexpectedFailure)
              .message,
        );
      case QuestionsAppwriteDataSourceAppwriteFailure:
        repoFailure = QuestionRepositoryExternalServiceErrorFailure(
          message:
              (dataSourceFailure as QuestionsAppwriteDataSourceAppwriteFailure)
                  .message,
        );
    }

    _logger.error(repoFailure.toString());
    return repoFailure;
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> updateSingle(
    Question question,
  ) =>
      throw UnimplementedError();

  @override
  Future<Result<Stream<List<Question>>, QuestionRepositoryFailure>>
      watchAll() async {
    _logger.debug('Watching questions...');

    await _emitQuestions();

    _appwriteDataSource
        .watchForQuestionCollectionUpdate()
        .listen(_onQuestionsUpdate);

    return Ok(_questionsStreamController.stream);
  }

  Future<void> _onQuestionsUpdate(_) async {
    _logger.debug('Questions updated');

    await _emitQuestions();
  }

  Future<void> _emitQuestions() async {
    _logger.debug('Fetching questions...');

    final questionsListModel = await _appwriteDataSource.getAllQuestions();

    _logger.debug('Fetched ${questionsListModel.total} questions');

    final questions =
        questionsListModel.questions.map((e) => e.toQuestion()).toList();

    _questionsStreamController.add(questions);
  }
}
