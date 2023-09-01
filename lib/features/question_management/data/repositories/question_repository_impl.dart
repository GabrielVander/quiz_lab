import 'dart:async';

import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/auth_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_permission_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_creation_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_list_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_option_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/profile_collection_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/features/question_management/domain/entities/draft_question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  QuestionRepositoryImpl({
    required this.logger,
    required this.questionsAppwriteDataSource,
    required this.profileAppwriteDataSource,
    required this.authAppwriteDataSource,
  });

  final QuizLabLogger logger;
  final QuestionCollectionAppwriteDataSource questionsAppwriteDataSource;
  final ProfileCollectionAppwriteDataSource profileAppwriteDataSource;
  final AuthAppwriteDataSource authAppwriteDataSource;

  final _questionsStreamController = StreamController<List<Question>>();

  @override
  Future<Result<Unit, String>> createSingle(DraftQuestion question) async {
    logger.debug('Creating question...');

    final creationModel = await _toCreationModel(question);

    return (await questionsAppwriteDataSource.createSingle(creationModel))
        .inspect((_) => logger.debug('Question created successfully'))
        .map((_) => unit)
        .inspectErr(logger.error)
        .mapErr((_) => 'Failed to create question');
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> deleteSingle(QuestionId id) async {
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
  Future<Result<Question, QuestionRepositoryFailure>> getSingle(QuestionId id) async {
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

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> updateSingle(Question question) => throw UnimplementedError();

  @override
  Future<Result<Stream<List<Question>>, String>> watchAll() async {
    logger.debug('Watching questions...');

    await _emitQuestions();

    return (await questionsAppwriteDataSource.watchForUpdate())
        .inspect((stream) => stream.listen(_onQuestionsUpdate))
        .map((_) => _questionsStreamController.stream)
        .mapErr((_) => 'Unable to watch questions');
  }

  Future<AppwriteQuestionCreationModel> _toCreationModel(DraftQuestion question) async {
    final ownerId = await _getCurrentUserId();

    return AppwriteQuestionCreationModel(
      ownerId: ownerId,
      title: question.title,
      description: question.description,
      options: question.options
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
  }

  Future<String?> _getCurrentUserId() async {
    logger.debug('Retrieving owner id...');

    return (await authAppwriteDataSource.getCurrentUser()).mapOr(fallback: null, okMap: (user) => user.$id);
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

  Future<void> _onQuestionsUpdate(_) async {
    logger.debug('Questions updated');

    await _emitQuestions();
  }

  Future<void> _emitQuestions() async {
    logger.debug('Fetching questions...');

    (await questionsAppwriteDataSource.getAll())
        .inspect((value) => logger.debug('Fetched ${value.total} questions'))
        .when(ok: _mapQuestions, err: (err) => logger.error(err.toString()));
  }

  Future<List<Question>> _mapQuestions(AppwriteQuestionListModel model) async {
    final questions = <Question>[];

    for (final questionModel in model.questions) {
      final ownerId = questionModel.profile;

      if (ownerId != null) {
        final result = await profileAppwriteDataSource.fetchSingle(ownerId);

        if (result.isOk) {
          final profileModel = result.unwrap();
          questions.add(questionModel.copyWith(profile: profileModel.displayName).toQuestion());
          continue;
        }
      }
      questions.add(questionModel.toQuestion());
    }

    _questionsStreamController.add(questions);
    return questions;
  }
}
