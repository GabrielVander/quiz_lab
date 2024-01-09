import 'dart:async';

import 'package:okay/okay.dart';
import 'package:quiz_lab/common/data/data_sources/questions_collection_appwrite_data_source.dart';
import 'package:quiz_lab/common/data/dto/appwrite_question_dto.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/features/answer_question/domain/entities/answerable_question.dart';
import 'package:quiz_lab/features/answer_question/domain/repositories/question_repository.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_question_option_dto.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  QuestionRepositoryImpl({
    required this.logger,
    required this.questionsAppwriteDataSource,
    required this.uuidGenerator,
  });

  final QuizLabLogger logger;
  final QuestionCollectionAppwriteDataSource questionsAppwriteDataSource;
  final ResourceUuidGenerator uuidGenerator;

  @override
  Future<Result<AnswerableQuestion, String>> fetchQuestionWithId(String id) async {
    logger.debug('Fetching question with given id...');

    return (await questionsAppwriteDataSource.fetchSingle(id))
        .inspect((_) => logger.debug('Question fetched successfully'))
        .map(_toAnswerableQuestion)
        .inspectErr((e) => logger.error(e.toString()))
        .mapErr((_) => 'Unable to fetch question with given id');
  }

  AnswerableQuestion _toAnswerableQuestion(AppwriteQuestionDto question) => AnswerableQuestion(
        id: question.id,
        title: question.title,
        description: question.description,
        difficulty: _mapDifficulty(question.difficulty),
        answers: question.options.map(_toAnswer).toList(),
      );

  Answer _toAnswer(AppwriteQuestionOptionDto option) => Answer(
        id: uuidGenerator.generate(),
        description: option.description,
        isCorrect: option.isCorrect,
      );

  QuestionDifficulty _mapDifficulty(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return QuestionDifficulty.easy;
      case 'medium':
        return QuestionDifficulty.medium;
      case 'hard':
        return QuestionDifficulty.hard;
      default:
        return QuestionDifficulty.unknown;
    }
  }
}
