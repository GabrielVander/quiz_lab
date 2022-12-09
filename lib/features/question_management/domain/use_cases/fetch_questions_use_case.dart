import '../entities/question.dart';
import '../repositories/question_repository.dart';

class WatchAllQuestionsUseCase {
  const WatchAllQuestionsUseCase({
    required QuestionRepository questionRepository,
  }) : _questionRepository = questionRepository;

  final QuestionRepository _questionRepository;

  Future<Stream<Question>> execute() async {
    final streamResult = await _questionRepository.watchAll();
    return streamResult.ok!;
  }
}
