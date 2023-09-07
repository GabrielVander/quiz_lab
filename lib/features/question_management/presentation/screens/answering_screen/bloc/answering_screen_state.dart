part of 'answering_screen_cubit.dart';

abstract class AnsweringScreenState extends Equatable {
  const AnsweringScreenState();
}

class QuestionDisplayInitial extends AnsweringScreenState {
  const QuestionDisplayInitial() : super();

  @override
  List<Object?> get props => [];
}

class QuestionDisplayLoading extends AnsweringScreenState {
  const QuestionDisplayLoading() : super();

  @override
  List<Object?> get props => [];
}

class QuestionDisplayTitleUpdated extends AnsweringScreenState {
  const QuestionDisplayTitleUpdated({
    required this.value,
  }) : super();

  final String value;

  @override
  List<Object?> get props => [value];
}

class QuestionDisplayDifficultyUpdated extends AnsweringScreenState {
  const QuestionDisplayDifficultyUpdated({
    required this.value,
  }) : super();

  final String value;

  @override
  List<Object?> get props => [value];
}

class QuestionDisplayDescriptionUpdated extends AnsweringScreenState {
  const QuestionDisplayDescriptionUpdated({
    required this.value,
  }) : super();

  final String value;

  @override
  List<Object?> get props => [value];
}

class QuestionDisplayAnswersUpdated extends AnsweringScreenState {
  const QuestionDisplayAnswersUpdated({
    required this.value,
  }) : super();

  final List<QuestionAnswerInfo> value;

  @override
  List<Object?> get props => [value];
}

class QuestionDisplayAnswerOptionWasSelected extends AnsweringScreenState {
  const QuestionDisplayAnswerOptionWasSelected({required this.id}) : super();

  final String id;

  @override
  List<Object?> get props => [id];
}

class QuestionDisplayShowAnswerButton extends AnsweringScreenState {
  const QuestionDisplayShowAnswerButton() : super();

  @override
  List<Object?> get props => [];
}

class QuestionDisplayHideAnswerButton extends AnsweringScreenState {
  const QuestionDisplayHideAnswerButton() : super();

  @override
  List<Object?> get props => [];
}

class QuestionDisplayAnswerButtonEnabled extends AnsweringScreenState {
  const QuestionDisplayAnswerButtonEnabled() : super();

  @override
  List<Object?> get props => [];
}

class QuestionDisplayShowResult extends AnsweringScreenState {
  const QuestionDisplayShowResult({
    required this.correctAnswerId,
    required this.selectedAnswerId,
  }) : super();

  final String correctAnswerId;
  final String selectedAnswerId;

  @override
  List<Object?> get props => [correctAnswerId, selectedAnswerId];
}

class QuestionDisplayGoHome extends AnsweringScreenState {
  const QuestionDisplayGoHome() : super();

  @override
  List<Object?> get props => [];
}

class QuestionDisplayError extends AnsweringScreenState {
  const QuestionDisplayError() : super();

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
