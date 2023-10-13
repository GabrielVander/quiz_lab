import 'package:okay/okay.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/answer_question/domain/repositories/question_repository.dart';

// ignore: one_member_abstracts
abstract interface class GetQuestionWithId {
  Future<Result<Question, Unit>> call(String? id);
}

class GetQuestionWithIdImpl implements GetQuestionWithId {
  GetQuestionWithIdImpl({
    required this.logger,
    required this.questionRepository,
  });

  final QuizLabLogger logger;

  final QuestionRepository questionRepository;

  @override
  Future<Result<Question, Unit>> call(String? id) async {
    logger.debug('Executing...');

    if (id == null) {
      logger.error('Unable to get question: No id given');
      return const Err(unit);
    }

    return (await questionRepository.fetchQuestionWithId(id))
        .inspect((_) => logger.debug('Question retrieved'))
        .inspectErr(logger.error)
        .mapErr((_) => unit);
  }
}
