import 'package:quiz_lab/core/utils/resource_uuid_generator.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/factories/repository_factory.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/create_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/delete_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/update_question_use_case.dart';
import 'package:quiz_lab/features/question_management/domain/use_cases/watch_all_questions_use_case.dart';
import 'package:uuid/uuid.dart';

class UseCaseFactory {
  const UseCaseFactory({
    required RepositoryFactory repositoryFactory,
  }) : _repositoryFactory = repositoryFactory;

  final RepositoryFactory _repositoryFactory;

  WatchAllQuestionsUseCase makeWatchAllQuestionsUseCase() {
    final questionRepository = _repositoryFactory.makeQuestionRepository();

    return WatchAllQuestionsUseCase(questionRepository: questionRepository);
  }

  CreateQuestionUseCase makeCreateQuestionUseCase() {
    return CreateQuestionUseCase(
      repositoryFactory: _repositoryFactory,
      uuidGenerator: const ResourceUuidGenerator(uuid: Uuid()),
    );
  }

  UpdateQuestionUseCase makeUpdateQuestionUseCase() {
    return UpdateQuestionUseCase(
      repositoryFactory: _repositoryFactory,
    );
  }

  DeleteQuestionUseCase makeDeleteQuestionUseCase() {
    return DeleteQuestionUseCase(
      repositoryFactory: _repositoryFactory,
    );
  }
}
