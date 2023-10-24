part of 'question_answering_cubit.dart';

abstract class QuestionAnsweringState extends Equatable {
  const QuestionAnsweringState();
}

class QuestionAnsweringInitial extends QuestionAnsweringState {
  const QuestionAnsweringInitial() : super();

  @override
  List<Object?> get props => [];
}

class QuestionAnsweringLoading extends QuestionAnsweringState {
  const QuestionAnsweringLoading() : super();

  @override
  List<Object?> get props => [];
}

class QuestionAnsweringQuestionViewModelUpdated extends QuestionAnsweringState {
  const QuestionAnsweringQuestionViewModelUpdated({required this.viewModel}) : super();

  final QuestionViewModel viewModel;

  @override
  List<Object?> get props => [viewModel];
}

class QuestionAnsweringGoHome extends QuestionAnsweringState {
  const QuestionAnsweringGoHome() : super();

  @override
  List<Object?> get props => [];
}

class QuestionAnsweringError extends QuestionAnsweringState {
  const QuestionAnsweringError({required this.message}) : super();

  final String message;

  @override
  List<Object?> get props => [];
}
