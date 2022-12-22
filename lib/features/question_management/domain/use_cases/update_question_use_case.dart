import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/factories/repository_factory.dart';

class UpdateQuestionUseCase {
  const UpdateQuestionUseCase({
    required RepositoryFactory repositoryFactory,
  }) : _repositoryFactory = repositoryFactory;

  final RepositoryFactory _repositoryFactory;

  Future<Result<Unit, UpdateQuestionUseCaseFailure>> execute(
    Question questionToUpdate,
  ) async {
    final questionRepository = _repositoryFactory.makeQuestionRepository();
    final updateResult =
        await questionRepository.updateSingle(questionToUpdate);

    return updateResult.mapErr(
      (error) => UpdateQuestionUseCaseFailure.repositoryFailure(
        error.message,
      ),
    );
  }
}

abstract class UpdateQuestionUseCaseFailure extends Equatable {
  const UpdateQuestionUseCaseFailure._(this.message);

  factory UpdateQuestionUseCaseFailure.repositoryFailure(String message) =>
      _QuestionRepoFailure._(message);

  final String message;

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class _QuestionRepoFailure extends UpdateQuestionUseCaseFailure {
  const _QuestionRepoFailure._(super.message) : super._();
}
