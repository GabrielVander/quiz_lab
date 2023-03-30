import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/logger/impl/quiz_lab_logger_factory.dart';
import 'package:quiz_lab/core/utils/logger/quiz_lab_logger.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class GetSingleQuestionUseCase {
  GetSingleQuestionUseCase({
    required this.questionRepository,
  });

  final QuizLabLogger _logger =
      QuizLabLoggerFactory.createLogger<GetSingleQuestionUseCase>();

  final QuestionRepository questionRepository;

  Future<Result<Question, Unit>> execute(String? id) async {
    _logger.debug('Executing...');

    if (id == null) {
      _logger.error('Question id is null');
      return const Result.err(unit);
    }

    final questionResult = await questionRepository.getSingle(QuestionId(id));

    return questionResult.when(
      ok: (question) {
        _logger.debug('Returning question...');

        return Result.ok(question);
      },
      err: (failure) {
        _logger.error(failure.toString());

        return const Result.err(unit);
      },
    );
  }
}
