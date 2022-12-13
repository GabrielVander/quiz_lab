import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class DeleteQuestionUseCase {
  const DeleteQuestionUseCase({
    required this.questionRepository,
  });

  final QuestionRepository questionRepository;

  Future<void> execute(String questionId) async {
    await questionRepository.deleteSingle(questionId);
  }
}
