import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class UpdateQuestionUseCase {
  const UpdateQuestionUseCase({
    required this.questionRepository,
  });

  final QuestionRepository questionRepository;

  Future<void> execute(Question questionToUpdate) async {
    await questionRepository.updateSingle(questionToUpdate);
  }
}
