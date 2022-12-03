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

class QuestionsOverviewListUpdated extends QuestionsOverviewState {
  const QuestionsOverviewListUpdated({
    required this.viewModel,
  });

  final QuestionListViewModel viewModel;

  @override
  List<Object> get props => [
        viewModel,
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
