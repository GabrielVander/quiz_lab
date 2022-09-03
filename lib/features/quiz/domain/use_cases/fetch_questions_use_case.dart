import 'package:quiz_lab/features/quiz/domain/entities/question.dart';
import 'package:quiz_lab/features/quiz/domain/repositories/question_repository.dart';

class FetchQuestionsUseCase {
  const FetchQuestionsUseCase({
    required QuestionRepository questionRepository,
  }) : _questionRepository = questionRepository;

  final QuestionRepository _questionRepository;

  Future<Stream<Question>> execute() async {
    return _questionRepository.fetchAll();
  }
}
