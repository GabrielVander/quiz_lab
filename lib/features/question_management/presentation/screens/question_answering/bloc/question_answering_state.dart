part of 'question_answering_cubit.dart';

abstract class AnsweringScreenState extends Equatable {
  const AnsweringScreenState();
}

class AnsweringScreenInitial extends AnsweringScreenState {
  const AnsweringScreenInitial() : super();

  @override
  List<Object?> get props => [];
}

class AnsweringScreenLoading extends AnsweringScreenState {
  const AnsweringScreenLoading() : super();

  @override
  List<Object?> get props => [];
}

class AnsweringScreenTitleUpdated extends AnsweringScreenState {
  const AnsweringScreenTitleUpdated({
    required this.value,
  }) : super();

  final String value;

  @override
  List<Object?> get props => [value];
}

class AnsweringScreenDifficultyUpdated extends AnsweringScreenState {
  const AnsweringScreenDifficultyUpdated({
    required this.value,
  }) : super();

  final String value;

  @override
  List<Object?> get props => [value];
}

class AnsweringScreenDescriptionUpdated extends AnsweringScreenState {
  const AnsweringScreenDescriptionUpdated({
    required this.value,
  }) : super();

  final String value;

  @override
  List<Object?> get props => [value];
}

class AnsweringScreenAnswersUpdated extends AnsweringScreenState {
  const AnsweringScreenAnswersUpdated({
    required this.value,
  }) : super();

  final List<QuestionAnswerInfo> value;

  @override
  List<Object?> get props => [value];
}

class AnsweringScreenAnswerOptionWasSelected extends AnsweringScreenState {
  const AnsweringScreenAnswerOptionWasSelected({required this.id}) : super();

  final String id;

  @override
  List<Object?> get props => [id];
}

class AnsweringScreenShowAnswerButton extends AnsweringScreenState {
  const AnsweringScreenShowAnswerButton() : super();

  @override
  List<Object?> get props => [];
}

class AnsweringScreenHideAnswerButton extends AnsweringScreenState {
  const AnsweringScreenHideAnswerButton() : super();

  @override
  List<Object?> get props => [];
}

class AnsweringScreenAnswerButtonEnabled extends AnsweringScreenState {
  const AnsweringScreenAnswerButtonEnabled() : super();

  @override
  List<Object?> get props => [];
}

class AnsweringScreenShowResult extends AnsweringScreenState {
  const AnsweringScreenShowResult({
    required this.correctAnswerId,
    required this.selectedAnswerId,
  }) : super();

  final String correctAnswerId;
  final String selectedAnswerId;

  @override
  List<Object?> get props => [correctAnswerId, selectedAnswerId];
}

class AnsweringScreenGoHome extends AnsweringScreenState {
  const AnsweringScreenGoHome() : super();

  @override
  List<Object?> get props => [];
}

class AnsweringScreenError extends AnsweringScreenState {
  const AnsweringScreenError({required this.message}) : super();

  final String message;

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
