part of 'question_creation_cubit.dart';

abstract class QuestionCreationState extends Equatable {
  const QuestionCreationState();

  factory QuestionCreationState.initial() => QuestionCreationInitial();

  factory QuestionCreationState.displayUpdate({
    required QuestionCreationViewModel viewModel,
  }) =>
      QuestionCreationDisplayUpdate(viewModel: viewModel);

  factory QuestionCreationState.loading() => const Loading._();

  factory QuestionCreationState.success() => const Success._();

  factory QuestionCreationState.failure({required String message}) =>
      CreationError._(message: message);

  factory QuestionCreationState.emptyTitle() =>
      const QuestionCreationEmptyTitle._();

  factory QuestionCreationState.titleOk() =>
      const QuestionCreationTitleIsOk._();

  @override
  bool get stringify => true;
}

class QuestionCreationInitial extends QuestionCreationState {
  @override
  List<Object> get props => [];
}

class QuestionCreationDisplayUpdate extends QuestionCreationState {
  const QuestionCreationDisplayUpdate({
    required this.viewModel,
  });

  final QuestionCreationViewModel viewModel;

  @override
  List<Object> get props => [
        viewModel,
      ];
}

class QuestionCreationQuestionCreated extends QuestionCreationState {
  @override
  List<Object> get props => [];
}

class CreationError extends QuestionCreationState {
  const CreationError._({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class Loading extends QuestionCreationState {
  const Loading._();

  @override
  List<Object> get props => [];
}

class Success extends QuestionCreationState {
  const Success._();

  @override
  List<Object> get props => [];
}

class QuestionCreationEmptyTitle extends QuestionCreationState {
  const QuestionCreationEmptyTitle._();

  @override
  List<Object> get props => [];
}

class QuestionCreationTitleIsOk extends QuestionCreationState {
  const QuestionCreationTitleIsOk._();

  @override
  List<Object> get props => [];
}
