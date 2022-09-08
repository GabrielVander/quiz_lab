part of 'questions_overview_cubit.dart';

abstract class QuestionsOverviewState extends Equatable {
  const QuestionsOverviewState();
}

class QuestionsOverviewInitial extends QuestionsOverviewState {
  @override
  List<Object> get props => [];
}

class QuestionsOverviewLoading extends QuestionsOverviewState {
  @override
  List<Object> get props => [];
}

class QuestionsOverviewLoaded extends QuestionsOverviewState {
  const QuestionsOverviewLoaded({
    required this.questions,
  });

  final List<QuestionOverviewViewModel> questions;

  @override
  List<Object> get props => [
        questions,
      ];
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
