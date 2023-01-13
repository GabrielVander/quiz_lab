part of 'questions_overview_cubit.dart';

@immutable
abstract class QuestionsOverviewState {
  const QuestionsOverviewState();

  factory QuestionsOverviewState.initial() =>
      const QuestionsOverviewInitial._();

  factory QuestionsOverviewState.loading() =>
      const QuestionsOverviewLoading._();

  factory QuestionsOverviewState.viewModelUpdated({
    required QuestionsOverviewViewModel viewModel,
  }) =>
      QuestionsOverviewViewModelUpdated._(viewModel: viewModel);

  factory QuestionsOverviewState.errorOccurred({required String message}) =>
      QuestionsOverviewErrorOccurred._(message: message);
}

@immutable
class QuestionsOverviewInitial extends QuestionsOverviewState {
  const QuestionsOverviewInitial._();
}

@immutable
class QuestionsOverviewLoading extends QuestionsOverviewState {
  const QuestionsOverviewLoading._();
}

@immutable
class QuestionsOverviewViewModelUpdated extends QuestionsOverviewState {
  const QuestionsOverviewViewModelUpdated._({
    required this.viewModel,
  });

  final QuestionsOverviewViewModel viewModel;
}

@immutable
class QuestionsOverviewErrorOccurred extends QuestionsOverviewState {
  const QuestionsOverviewErrorOccurred._({
    required this.message,
  }) : super();

  final String message;
}
