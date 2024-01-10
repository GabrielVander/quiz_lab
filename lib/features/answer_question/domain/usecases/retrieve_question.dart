import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/features/answer_question/domain/entities/answerable_question.dart';
import 'package:quiz_lab/features/answer_question/domain/repositories/question_repository.dart';
import 'package:rust_core/result.dart';

// ignore: one_member_abstracts
abstract interface class RetrieveQuestion {
  Future<Result<AnswerableQuestion, String>> call(String? id);
}

class RetrieveQuestionImpl implements RetrieveQuestion {
  RetrieveQuestionImpl({
    required this.logger,
    required this.questionRepository,
  });

  final QuizLabLogger logger;

  final QuestionRepository questionRepository;

  @override
  Future<Result<AnswerableQuestion, String>> call(String? id) async {
    logger.debug('Executing...');

    if (id == null) {
      return const Err('Unable to get question: No id given');
    }

    return (await questionRepository.fetchQuestionWithId(id))
        .inspect((_) => logger.debug('Question retrieved'))
        .inspectErr(logger.error)
        .mapErr((_) => 'Unable to retrieve question');
  }
}
