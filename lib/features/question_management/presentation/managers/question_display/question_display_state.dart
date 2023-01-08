part of 'question_display_cubit.dart';

@immutable
abstract class QuestionDisplayState {
  const QuestionDisplayState._();

  factory QuestionDisplayState.initial() => const QuestionDisplayInitial._();

  factory QuestionDisplayState.viewModelUpdated(
    QuestionDisplayViewModel viewModel,
  ) =>
      QuestionDisplayViewModelUpdated._(viewModel: viewModel);

  factory QuestionDisplayState.questionAnsweredCorrectly() =>
      const QuestionDisplayQuestionAnsweredCorrectly._();

  factory QuestionDisplayState.questionAnsweredIncorrectly(
    QuestionDisplayOptionViewModel correctAnswer,
  ) =>
      QuestionDisplayQuestionAnsweredIncorrectly._(
        correctAnswer: correctAnswer,
      );

  factory QuestionDisplayState.failure() => const QuestionDisplayFailure._();
}

class QuestionDisplayInitial extends QuestionDisplayState {
  const QuestionDisplayInitial._() : super._();
}

class QuestionDisplayViewModelUpdated extends QuestionDisplayState {
  const QuestionDisplayViewModelUpdated._({required this.viewModel})
      : super._();

  final QuestionDisplayViewModel viewModel;
}

class QuestionDisplayQuestionAnsweredCorrectly extends QuestionDisplayState {
  const QuestionDisplayQuestionAnsweredCorrectly._() : super._();
}

class QuestionDisplayQuestionAnsweredIncorrectly extends QuestionDisplayState {
  const QuestionDisplayQuestionAnsweredIncorrectly._({
    required this.correctAnswer,
  }) : super._();

  final QuestionDisplayOptionViewModel correctAnswer;
}

class QuestionDisplayFailure extends QuestionDisplayState {
  const QuestionDisplayFailure._() : super._();
}
