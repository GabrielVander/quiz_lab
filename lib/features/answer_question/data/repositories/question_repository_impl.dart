import 'dart:async';

import 'package:okay/okay.dart';
import 'package:quiz_lab/common/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/answer_question/domain/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  QuestionRepositoryImpl({
    required this.logger,
    required this.questionsAppwriteDataSource,
  });

  final QuizLabLogger logger;
  final QuestionCollectionAppwriteDataSource questionsAppwriteDataSource;

  @override
  Future<Result<Question, String>> fetchQuestionWithId(String id) async {
    logger.debug('Fetching question with given id...');

    return (await questionsAppwriteDataSource.fetchSingle(id))
        .inspect((_) => logger.debug('Question fetched successfully'))
        .map((dto) => dto.toQuestion())
        .inspectErr((e) => logger.error(e.toString()))
        .mapErr((_) => 'Unable to fetch question with given id');
  }
}
