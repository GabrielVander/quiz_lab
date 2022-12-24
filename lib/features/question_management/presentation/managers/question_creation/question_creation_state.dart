part of 'question_creation_cubit.dart';

abstract class QuestionCreationState extends Equatable {
  const QuestionCreationState();

  factory QuestionCreationState.initial() => const QuestionCreationInitial._();

  factory QuestionCreationState.displayUpdate({
    required QuestionCreationViewModel viewModel,
  }) =>
      QuestionCreationDisplayUpdate(viewModel: viewModel);

  factory QuestionCreationState.loading() => const Loading._();

  factory QuestionCreationState.success() =>
      const QuestionCreationHasSucceded._();

  factory QuestionCreationState.failure({required String details}) =>
      QuestionCreationHasFailed._(details: details);

  factory QuestionCreationState.titleIsEmpty() =>
      const QuestionCreationTitleIsEmpty._();

  factory QuestionCreationState.titleIsValid() =>
      const QuestionCreationTitleIsValid._();

  factory QuestionCreationState.descriptionIsEmpty() =>
      const QuestionCreationDescriptionIsEmpty._();

  factory QuestionCreationState.descriptionIsValid() =>
      const QuestionCreationDescriptionIsValid._();

  @override
  bool get stringify => true;
}

class QuestionCreationInitial extends QuestionCreationState {
  const QuestionCreationInitial._();

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

class QuestionCreationHasFailed extends QuestionCreationState {
  const QuestionCreationHasFailed._({required this.details});

  final String details;

  @override
  List<Object> get props => [details];
}

class QuestionCreationHasSucceded extends QuestionCreationState {
  const QuestionCreationHasSucceded._();

  @override
  List<Object> get props => [];
}

class Loading extends QuestionCreationState {
  const Loading._();

  @override
  List<Object> get props => [];
}

class QuestionCreationTitleIsEmpty extends QuestionCreationState {
  const QuestionCreationTitleIsEmpty._();

  @override
  List<Object> get props => [];
}

class QuestionCreationTitleIsValid extends QuestionCreationState {
  const QuestionCreationTitleIsValid._();

  @override
  List<Object> get props => [];
}

class QuestionCreationDescriptionIsEmpty extends QuestionCreationState {
  const QuestionCreationDescriptionIsEmpty._();

  @override
  List<Object> get props => [];
}

class QuestionCreationDescriptionIsValid extends QuestionCreationState {
  const QuestionCreationDescriptionIsValid._();

  @override
  List<Object> get props => [];
}
