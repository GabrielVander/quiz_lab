part of 'question_creation_cubit.dart';

@immutable
abstract class QuestionCreationState {
  const QuestionCreationState();

  factory QuestionCreationState.initial() => const QuestionCreationInitial._();

  factory QuestionCreationState.loading() => const QuestionCreationLoading._();

  factory QuestionCreationState.goBack() => const QuestionCreationGoBack._();

  factory QuestionCreationState.viewModelUpdated(
    QuestionCreationViewModel viewModel,
  ) =>
      QuestionCreationViewModelUpdated._(viewModel: viewModel);
}

@immutable
class QuestionCreationInitial extends QuestionCreationState {
  const QuestionCreationInitial._();
}

@immutable
class QuestionCreationLoading extends QuestionCreationState {
  const QuestionCreationLoading._();
}

@immutable
class QuestionCreationGoBack extends QuestionCreationState {
  const QuestionCreationGoBack._();
}

@immutable
class QuestionCreationViewModelUpdated extends QuestionCreationState {
  const QuestionCreationViewModelUpdated._({
    required this.viewModel,
  }) : super();

  final QuestionCreationViewModel viewModel;
}
