import 'package:quiz_lab/features/quiz/domain/entities/question.dart';
import 'package:quiz_lab/features/quiz/domain/repositories/question_repository.dart';

class FetchAllQuestionsUseCase {
  const FetchAllQuestionsUseCase({
    required QuestionRepository questionRepository,
  }) : _questionRepository = questionRepository;

  final QuestionRepository _questionRepository;

  Stream<List<Question>> execute() {
    return _questionRepository.fetchAll();
  }
}
