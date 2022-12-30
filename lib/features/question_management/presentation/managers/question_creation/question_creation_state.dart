part of 'question_creation_cubit.dart';

abstract class QuestionCreationState extends Equatable {
  const QuestionCreationState();

  factory QuestionCreationState.initial() => const QuestionCreationInitial._();

  factory QuestionCreationState.viewModelSubjectUpdated(
    BehaviorSubject<QuestionCreationViewModel> viewModelSubject,
  ) =>
      QuestionCreationViewModelSubjectUpdated._(
        viewModelSubject: viewModelSubject,
      );

  factory QuestionCreationState.saving() =>
      const QuestionCreationSavingQuestion._();

  factory QuestionCreationState.success() =>
      const QuestionCreationHasSucceeded._();

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

  factory QuestionCreationState.difficultyIsNotSet() =>
      const QuestionCreationDifficultyIsNotSet._();

  factory QuestionCreationState.difficultyIsSet() =>
      const QuestionCreationDifficultyIsSet._();

  factory QuestionCreationState.optionsUpdated(
    List<SingleOptionViewModel> options,
  ) =>
      QuestionCreationOptionsUpdated._(options: options);

  factory QuestionCreationState.optionIsEmpty(String id) =>
      QuestionCreationOptionIsEmpty._(id: id);

  factory QuestionCreationState.optionLimitReached() =>
      const QuestionCreationOptionLimitReached._();

  factory QuestionCreationState.noCorrectOption() =>
      const QuestionCreationNoCorrectOption._();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class QuestionCreationInitial extends QuestionCreationState {
  const QuestionCreationInitial._();
}

class QuestionCreationViewModelSubjectUpdated extends QuestionCreationState {
  const QuestionCreationViewModelSubjectUpdated._({
    required this.viewModelSubject,
  }) : super();

  final BehaviorSubject<QuestionCreationViewModel> viewModelSubject;
}

class QuestionCreationHasFailed extends QuestionCreationState {
  const QuestionCreationHasFailed._({required this.details});

  final String details;

  @override
  List<Object> get props => super.props..addAll([details]);
}

class QuestionCreationHasSucceeded extends QuestionCreationState {
  const QuestionCreationHasSucceeded._();
}

class QuestionCreationSavingQuestion extends QuestionCreationState {
  const QuestionCreationSavingQuestion._();
}

class QuestionCreationTitleIsEmpty extends QuestionCreationState {
  const QuestionCreationTitleIsEmpty._();
}

class QuestionCreationTitleIsValid extends QuestionCreationState {
  const QuestionCreationTitleIsValid._();
}

class QuestionCreationDescriptionIsEmpty extends QuestionCreationState {
  const QuestionCreationDescriptionIsEmpty._();
}

class QuestionCreationDescriptionIsValid extends QuestionCreationState {
  const QuestionCreationDescriptionIsValid._();
}

class QuestionCreationDifficultyIsNotSet extends QuestionCreationState {
  const QuestionCreationDifficultyIsNotSet._();
}

class QuestionCreationDifficultyIsSet extends QuestionCreationState {
  const QuestionCreationDifficultyIsSet._();
}

class QuestionCreationOptionsUpdated extends QuestionCreationState {
  const QuestionCreationOptionsUpdated._({
    required this.options,
  });

  final List<SingleOptionViewModel> options;

  @override
  List<Object> get props => [options];
}

class QuestionCreationOptionIsEmpty extends QuestionCreationState {
  const QuestionCreationOptionIsEmpty._({required this.id});

  final String id;

  @override
  List<Object> get props => super.props..addAll([id]);
}

class QuestionCreationOptionLimitReached extends QuestionCreationState {
  const QuestionCreationOptionLimitReached._();
}

class QuestionCreationNoCorrectOption extends QuestionCreationState {
  const QuestionCreationNoCorrectOption._();
}
