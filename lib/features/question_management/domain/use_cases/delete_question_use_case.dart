import 'package:quiz_lab/features/question_management/domain/repositories/factories/repository_factory.dart';

class DeleteQuestionUseCase {
  const DeleteQuestionUseCase({
    required RepositoryFactory repositoryFactory,
  }) : _repositoryFactory = repositoryFactory;

  final RepositoryFactory _repositoryFactory;

  Future<void> execute(String questionId) async {
    final questionRepository = _repositoryFactory.makeQuestionRepository();

    await questionRepository.deleteSingle(questionId);
  }
}
