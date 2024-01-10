import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:rust_core/result.dart';

class GetRandomQuestionIdUseCase {
  Result<String, String> execute(Iterable<Question> questions) {
    return const Err('Not implemented');
  }
}
