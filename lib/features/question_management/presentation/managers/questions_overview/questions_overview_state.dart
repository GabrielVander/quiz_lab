part of 'questions_overview_cubit.dart';

@immutable
abstract class QuestionsOverviewState {
  const QuestionsOverviewState();
}

@immutable
class QuestionsOverviewInitial extends QuestionsOverviewState {
  const QuestionsOverviewInitial();
}

@immutable
class QuestionsOverviewLoading extends QuestionsOverviewState {
  const QuestionsOverviewLoading();
}

@immutable
class QuestionsOverviewViewModelUpdated extends QuestionsOverviewState {
  const QuestionsOverviewViewModelUpdated({
    required this.viewModel,
  });

  final QuestionsOverviewViewModel viewModel;
}

@immutable
class QuestionsOverviewErrorOccurred extends QuestionsOverviewState {
  const QuestionsOverviewErrorOccurred({
    required this.message,
  }) : super();

  final String message;
}

@immutable
class QuestionsOverviewOpenQuestion extends QuestionsOverviewState {
  const QuestionsOverviewOpenQuestion({
    required this.questionId,
  }) : super();

  final String questionId;
}
