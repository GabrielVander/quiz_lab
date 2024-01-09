import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/core/utils/unit.dart';
import 'package:quiz_lab/features/question_management/domain/repositories/question_repository.dart';

class UpdateQuestionUseCase {
  const UpdateQuestionUseCase({
    required QuestionRepository questionRepository,
  }) : _questionRepository = questionRepository;

  final QuestionRepository _questionRepository;

  Future<Result<Unit, UpdateQuestionUseCaseFailure>> execute(
    Question questionToUpdate,
  ) async {
    final updateResult = await _questionRepository.updateSingle(questionToUpdate);

    return updateResult.mapErr(
      (error) => UpdateQuestionUseCaseFailure.repositoryFailure(
        error.message,
      ),
    );
  }
}

abstract class UpdateQuestionUseCaseFailure extends Equatable {
  const UpdateQuestionUseCaseFailure._(this.message);

  factory UpdateQuestionUseCaseFailure.repositoryFailure(String message) => _QuestionRepoFailure._(message);

  final String message;

  @override
  List<Object> get props => [message];

  @override
  bool get stringify => true;
}

class _QuestionRepoFailure extends UpdateQuestionUseCaseFailure {
  const _QuestionRepoFailure._(super.message) : super._();
}
