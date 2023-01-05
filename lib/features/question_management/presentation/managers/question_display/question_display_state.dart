part of 'question_display_cubit.dart';

@immutable
abstract class QuestionDisplayState {
  const QuestionDisplayState._();

  factory QuestionDisplayState.initial() => const QuestionDisplayInitial._();

  factory QuestionDisplayState.subjectUpdated(
    BehaviorSubject<QuestionDisplayViewModel> subject,
  ) =>
      QuestionDisplayViewModelSubjectUpdated._(subject: subject);
}

class QuestionDisplayInitial extends QuestionDisplayState {
  const QuestionDisplayInitial._() : super._();
}

class QuestionDisplayViewModelSubjectUpdated extends QuestionDisplayState {
  const QuestionDisplayViewModelSubjectUpdated._({required this.subject})
      : super._();

  final BehaviorSubject<QuestionDisplayViewModel> subject;
}
