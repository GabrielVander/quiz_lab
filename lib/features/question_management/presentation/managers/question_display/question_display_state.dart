part of 'question_display_cubit.dart';

@immutable
abstract class QuestionDisplayState {
  const QuestionDisplayState();
}

class QuestionDisplayInitial extends QuestionDisplayState {
  const QuestionDisplayInitial() : super();
}

class QuestionDisplayViewModelUpdated extends QuestionDisplayState {
  const QuestionDisplayViewModelUpdated({required this.viewModel}) : super();

  final QuestionDisplayViewModel viewModel;
}

class QuestionDisplayQuestionAnsweredCorrectly extends QuestionDisplayState {
  const QuestionDisplayQuestionAnsweredCorrectly() : super();
}

class QuestionDisplayQuestionAnsweredIncorrectly extends QuestionDisplayState {
  const QuestionDisplayQuestionAnsweredIncorrectly({
    required this.correctAnswer,
  }) : super();

  final QuestionDisplayOptionViewModel correctAnswer;
}

class QuestionDisplayFailure extends QuestionDisplayState {
  const QuestionDisplayFailure() : super();
}

class QuestionDisplayGoHome extends QuestionDisplayState {
  const QuestionDisplayGoHome() : super();
}
