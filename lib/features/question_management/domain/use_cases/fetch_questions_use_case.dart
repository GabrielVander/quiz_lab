import '../entities/question.dart';
import '../repositories/question_repository.dart';

class WatchAllQuestionsUseCase {
  const WatchAllQuestionsUseCase({
    required QuestionRepository questionRepository,
  }) : _questionRepository = questionRepository;

  final QuestionRepository _questionRepository;

  Stream<List<Question>> execute() {
    return _questionRepository.watchAll();
  }
}
