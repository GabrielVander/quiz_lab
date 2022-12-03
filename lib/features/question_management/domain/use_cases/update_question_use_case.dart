import '../entities/question.dart';
import '../repositories/question_repository.dart';

class UpdateQuestionUseCase {
  const UpdateQuestionUseCase({
    required this.questionRepository,
  });

  final QuestionRepository questionRepository;

  Future<void> execute(Question questionToUpdate) async {
    await questionRepository.updateSingle(questionToUpdate);
  }
}
