part of 'question_creation_cubit.dart';

abstract class QuestionCreationState extends Equatable {
  const QuestionCreationState();
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
