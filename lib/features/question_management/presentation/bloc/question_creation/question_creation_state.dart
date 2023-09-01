part of 'question_creation_cubit.dart';

sealed class QuestionCreationState extends Equatable {
  const QuestionCreationState._();

  @override
  bool get stringify => false;
}

class QuestionCreationInitial extends QuestionCreationState {
  const QuestionCreationInitial() : super._();

  @override
  List<Object> get props => [];
}

class QuestionCreationLoading extends QuestionCreationState {
  const QuestionCreationLoading() : super._();

  @override
  List<Object> get props => [];
}

class QuestionCreationGoBack extends QuestionCreationState {
  const QuestionCreationGoBack() : super._();

  @override
  List<Object> get props => [];
}

// TODO(GabrielVander): This is bloated, each update should emit its own state
class QuestionCreationViewModelUpdated extends QuestionCreationState {
  const QuestionCreationViewModelUpdated({
    required this.viewModel,
  }) : super._();

  final QuestionCreationViewModel viewModel;

  @override
  List<Object> get props => [viewModel];
}

class QuestionCreationPublicStatusUpdated extends QuestionCreationState {
  const QuestionCreationPublicStatusUpdated({required this.isPublic}) : super._();

  final bool isPublic;

  @override
  String toString() => 'QuestionCreationPublicStatusUpdated{isPublic: $isPublic}';

  @override
  List<Object> get props => [isPublic];
}

class QuestionCreationHidePublicToggle extends QuestionCreationState {
  const QuestionCreationHidePublicToggle() : super._();

  @override
  List<Object> get props => [];
}

class QuestionCreationShowPublicToggle extends QuestionCreationState {
  const QuestionCreationShowPublicToggle() : super._();

  @override
  List<Object> get props => [];
}
