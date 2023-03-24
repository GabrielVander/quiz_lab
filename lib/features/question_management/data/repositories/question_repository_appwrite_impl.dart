import 'dart:async';

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
  final _logger =
      QuizLabLoggerFactory.createLogger<QuestionRepositoryAppwriteImpl>();

  final AppwriteDataSource _appwriteDataSource;

  final _questionsStreamController = StreamController<List<Question>>();

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> createSingle(
    Question question,
  ) async {
    _logger.debug('Creating question...');

    await _appwriteDataSource.createQuestion(
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
      ),
    );

    return const Result.ok(unit);
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> deleteSingle(QuestionId id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<Unit, QuestionRepositoryFailure>> updateSingle(
    Question question,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Result<Stream<List<Question>>, QuestionRepositoryFailure>>
      watchAll() async {
    _logger.debug('Watching questions...');

    await _emitQuestions();

    _appwriteDataSource
        .watchForQuestionCollectionUpdate()
        .listen(_onQuestionsUpdate);

    return Result.ok(_questionsStreamController.stream);
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
