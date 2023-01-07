part of 'question_display_cubit.dart';

@immutable
abstract class QuestionDisplayState {
  const QuestionDisplayState._();

  factory QuestionDisplayState.initial() => const QuestionDisplayInitial._();

  factory QuestionDisplayState.subjectUpdated(
    BehaviorSubject<QuestionDisplayViewModel> subject,
  ) =>
      QuestionDisplayViewModelSubjectUpdated._(subject: subject);

  factory QuestionDisplayState.questionAnsweredCorrectly() =>
      const QuestionDisplayQuestionAnsweredCorrectly._();

  factory QuestionDisplayState.questionAnsweredIncorrectly(
    QuestionDisplayOptionViewModel correctAnswer,
  ) =>
      QuestionDisplayQuestionAnsweredIncorrectly._(
        correctAnswer: correctAnswer,
      );
}

class QuestionDisplayInitial extends QuestionDisplayState {
  const QuestionDisplayInitial._() : super._();
}

class QuestionDisplayViewModelSubjectUpdated extends QuestionDisplayState {
  const QuestionDisplayViewModelSubjectUpdated._({required this.subject})
      : super._();

  final BehaviorSubject<QuestionDisplayViewModel> subject;
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
