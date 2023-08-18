import 'dart:async';

import 'package:okay/okay.dart';
import 'package:quiz_lab/core/data/data_sources/appwrite_data_source.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_permission_model.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_option_model.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_creation_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  QuestionRepositoryImpl({
    required this.logger,
    required this.appwriteDataSource,
    required this.questionsAppwriteDataSource,
  });

  final QuizLabLogger logger;
  final AppwriteDataSource appwriteDataSource;
  final QuestionCollectionAppwriteDataSource questionsAppwriteDataSource;

  final _questionsStreamController = StreamController<List<Question>>();

  @override
  Future<Result<Unit, String>> createSingle(Question question) async {
    logger.debug('Creating question...');

    final creationModel = _toCreationModel(question);

    return (await questionsAppwriteDataSource.createSingle(creationModel))
        .inspect((_) => logger.debug('Question created successfully'))
        .map((_) => unit)
        .inspectErr(logger.error)
        .mapErr((_) => 'Failed to create question');
  }

  AppwriteQuestionCreationModel _toCreationModel(Question question) => AppwriteQuestionCreationModel(
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
        permissions: question.isPublic ? [AppwritePermissionTypeModel.read(AppwritePermissionRoleModel.any())] : null,
      );

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> deleteSingle(
    QuestionId id,
  ) async {
    logger.debug('Deleting question...');

    final deletionResult = await questionsAppwriteDataSource.deleteSingle(id.value);

    return deletionResult.when(
      ok: (_) {
        logger.debug('Question deleted successfully');
        return const Ok(unit);
      },
      err: (failure) => Err(_mapQuestionsAppwriteDataSourceFailure(failure)),
    );
  }

  @override
  Future<Result<Question, QuestionRepositoryFailure>> getSingle(
    QuestionId id,
  ) async {
    logger.debug('Getting question...');

    final fetchResult = await questionsAppwriteDataSource.fetchSingle(id.value);

    return fetchResult.when(
      ok: (model) {
        logger.debug('Question fetched successfully');
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
          message: (dataSourceFailure as QuestionsAppwriteDataSourceUnexpectedFailure).message,
        );
      case QuestionsAppwriteDataSourceAppwriteFailure:
        repoFailure = QuestionRepositoryExternalServiceErrorFailure(
          message: (dataSourceFailure as QuestionsAppwriteDataSourceAppwriteFailure).message,
        );
    }

    logger.error(repoFailure.toString());
    return repoFailure;
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> updateSingle(
    Question question,
  ) =>
      throw UnimplementedError();

  @override
  Future<Result<Stream<List<Question>>, QuestionRepositoryFailure>> watchAll() async {
    logger.debug('Watching questions...');

    await _emitQuestions();

    appwriteDataSource.watchForQuestionCollectionUpdate().listen(_onQuestionsUpdate);

    return Ok(_questionsStreamController.stream);
  }

  Future<void> _onQuestionsUpdate(_) async {
    logger.debug('Questions updated');

    await _emitQuestions();
  }

  Future<void> _emitQuestions() async {
    logger.debug('Fetching questions...');

    final questionsListModel = await appwriteDataSource.getAllQuestions();

    logger.debug('Fetched ${questionsListModel.total} questions');

    final questions = questionsListModel.questions.map((e) => e.toQuestion()).toList();

    _questionsStreamController.add(questions);
  }
}
