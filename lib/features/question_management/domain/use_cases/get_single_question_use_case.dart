import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class GetSingleQuestionUseCase {
  const GetSingleQuestionUseCase({
    required this.questionRepository,
  });

  final QuestionRepository questionRepository;

  Future<Result<Question, String>> execute(String? id) async {
    if (id == null) {
      return const Result.err('Unable to find question');
    }

    final result = await questionRepository.watchAll();

    if (result.isErr) {
      return Result.err(result.err!.message);
    }

    final findResult = await _findTargetQuestionFromStream(id, result.ok!);

    return findResult.mapErr((error) => 'Unable to find question');
  }

  Future<Result<Question, Unit>> _findTargetQuestionFromStream(
    String id,
    Stream<List<Question>> stream,
  ) async {
    final emittedQuestions = await stream.take(1).toList();

    for (final questions in emittedQuestions) {
      try {
        final question = questions.firstWhere((q) => q.id == id);

        return Result.ok(question);
        // ignore: avoid_catching_errors
      } on StateError {
        continue;
      }
    }

    return const Result.err(unit);
  }
}
