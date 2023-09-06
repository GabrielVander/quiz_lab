part of 'question_display_cubit.dart';

abstract class QuestionDisplayState extends Equatable {
  const QuestionDisplayState();
}

class QuestionDisplayInitial extends QuestionDisplayState {
  const QuestionDisplayInitial() : super();

  @override
  List<Object?> get props => [];
}

class QuestionDisplayLoading extends QuestionDisplayState {
  const QuestionDisplayLoading() : super();

  @override
  List<Object?> get props => [];
}

class QuestionDisplayShowAnswerButton extends QuestionDisplayState {
  const QuestionDisplayShowAnswerButton() : super();

  @override
  List<Object?> get props => [];
}

class QuestionDisplayHideAnswerButton extends QuestionDisplayState {
  const QuestionDisplayHideAnswerButton() : super();

  @override
  List<Object?> get props => [];
}

class QuestionDisplayAnswerOptionWasSelected extends QuestionDisplayState {
  const QuestionDisplayAnswerOptionWasSelected({required this.id}) : super();

  final String id;

  @override
  List<Object?> get props => [id];
}

class QuestionDisplayAnswerButtonEnabled extends QuestionDisplayState {
  const QuestionDisplayAnswerButtonEnabled() : super();

  @override
  List<Object?> get props => [];
}

class QuestionDisplayQuestionAnsweredCorrectly extends QuestionDisplayState {
  const QuestionDisplayQuestionAnsweredCorrectly() : super();

  @override
  List<Object?> get props => [];
}

class QuestionDisplayQuestionAnsweredIncorrectly extends QuestionDisplayState {
  const QuestionDisplayQuestionAnsweredIncorrectly() : super();

  @override
  List<Object?> get props => [];
}

class QuestionDisplayError extends QuestionDisplayState {
  const QuestionDisplayError() : super();

  @override
  List<Object?> get props => [];
}

class QuestionDisplayTitleUpdated extends QuestionDisplayState {
  const QuestionDisplayTitleUpdated({
    required this.value,
  }) : super();

  final String value;

  @override
  List<Object?> get props => [value];
}

class QuestionDisplayDifficultyUpdated extends QuestionDisplayState {
  const QuestionDisplayDifficultyUpdated({
    required this.value,
  }) : super();

  final String value;

  @override
  List<Object?> get props => [value];
}

class QuestionDisplayDescriptionUpdated extends QuestionDisplayState {
  const QuestionDisplayDescriptionUpdated({
    required this.value,
  }) : super();

  final String value;

  @override
  List<Object?> get props => [value];
}

class QuestionDisplayAnswersUpdated extends QuestionDisplayState {
  const QuestionDisplayAnswersUpdated({
    required this.value,
  }) : super();

  final List<QuestionAnswerInfo> value;

  @override
  List<Object?> get props => [value];
}

class QuestionDisplayGoHome extends QuestionDisplayState {
  const QuestionDisplayGoHome() : super();

  @override
  List<Object?> get props => [];
}

class QuestionAnswerInfo extends Equatable {
  const QuestionAnswerInfo({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}
