import 'package:okay/okay.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';

class GetRandomQuestionIdUseCase {
  Result<String, String> execute(Iterable<Question> questions) {
    return const Err('Not implemented');
  }
}
