import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class DeleteQuestionUseCase {
  const DeleteQuestionUseCase({
    required QuestionRepository questionRepository,
  }) : _questionRepository = questionRepository;

  final QuestionRepository _questionRepository;

  Future<void> execute(String questionId) async {
    await _questionRepository.deleteSingle(questionId);
  }
}
