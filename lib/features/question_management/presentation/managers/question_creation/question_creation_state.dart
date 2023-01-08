part of 'question_creation_cubit.dart';

abstract class QuestionCreationState extends Equatable {
  const QuestionCreationState();

  factory QuestionCreationState.initial() => const QuestionCreationInitial._();

  factory QuestionCreationState.loading() => const QuestionCreationLoading._();

  factory QuestionCreationState.goBack() => const QuestionCreationGoBack._();

  factory QuestionCreationState.viewModelSubjectUpdated(
    BehaviorSubject<QuestionCreationViewModel> viewModelSubject,
  ) =>
      QuestionCreationViewModelSubjectUpdated._(
        viewModelSubject: viewModelSubject,
      );

  @override
  List<Object> get props => [];
}

class QuestionCreationInitial extends QuestionCreationState {
  const QuestionCreationInitial._();
}

class QuestionCreationLoading extends QuestionCreationState {
  const QuestionCreationLoading._();
}

class QuestionCreationGoBack extends QuestionCreationState {
  const QuestionCreationGoBack._();
}

class QuestionCreationViewModelSubjectUpdated extends QuestionCreationState {
  const QuestionCreationViewModelSubjectUpdated._({
    required this.viewModelSubject,
  }) : super();

  final BehaviorSubject<QuestionCreationViewModel> viewModelSubject;
}
