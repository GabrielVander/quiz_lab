part of 'questions_overview_cubit.dart';

abstract class QuestionsOverviewState extends Equatable {
  const QuestionsOverviewState();

  factory QuestionsOverviewState.initial() => const Initial._();

  factory QuestionsOverviewState.loading() => const Loading._();

  factory QuestionsOverviewState.questionListUpdated({
    required List<QuestionOverviewItemViewModel> questions,
  }) =>
      QuestionListUpdated._(questions: questions);

  factory QuestionsOverviewState.error({required String message}) =>
      QuestionsOverviewError._(message: message);

  @override
  List<Object> get props => [];
}

class Initial extends QuestionsOverviewState {
  const Initial._();
}

class Loading extends QuestionsOverviewState {
  const Loading._();
}

class QuestionListUpdated extends QuestionsOverviewState {
  const QuestionListUpdated._({
    required this.questions,
  });

  final List<QuestionOverviewItemViewModel> questions;

  @override
  List<Object> get props => super.props..addAll([questions]);
}

class QuestionsOverviewError extends QuestionsOverviewState {
  const QuestionsOverviewError._({
    required this.message,
  }) : super();

  final String message;

  @override
  List<Object> get props => super.props..addAll([message]);
}
