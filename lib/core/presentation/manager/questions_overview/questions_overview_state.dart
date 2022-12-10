part of 'questions_overview_cubit.dart';

abstract class QuestionsOverviewState extends Equatable {
  const QuestionsOverviewState();

  factory QuestionsOverviewState.initial() => QuestionsOverviewInitial();

  factory QuestionsOverviewState.loading() => QuestionsOverviewLoading();

  factory QuestionsOverviewState.listUpdated({
    required List<QuestionOverviewViewModel> questions,
  }) =>
      QuestionOverviewListUpdated._(questions: questions);

  factory QuestionsOverviewState.error({required String message}) =>
      QuestionsOverviewError._(message: message);
}

class QuestionsOverviewInitial extends QuestionsOverviewState {
  @override
  List<Object> get props => [];
}

class QuestionsOverviewLoading extends QuestionsOverviewState {
  @override
  List<Object> get props => [];
}

class QuestionOverviewListUpdated extends QuestionsOverviewState {
  const QuestionOverviewListUpdated._({
    required this.questions,
  });

  final List<QuestionOverviewViewModel> questions;

  @override
  List<Object> get props => [questions];
}

class QuestionsOverviewError extends QuestionsOverviewState {
  const QuestionsOverviewError._({
    required this.message,
  }) : super();

  final String message;

  @override
  List<Object> get props => [message];
}

class QuestionsOverviewShowShortDescription extends QuestionsOverviewState {
  const QuestionsOverviewShowShortDescription({
    required this.viewModel,
  });

  final ShowShortDescriptionViewModel viewModel;

  @override
  List<Object> get props => [
        viewModel,
      ];
}
