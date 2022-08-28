import 'package:equatable/equatable.dart';

class AssessmentOverviewViewModel extends Equatable {
  const AssessmentOverviewViewModel({
    required this.title,
    required this.amountOfQuestions,
    required this.answers,
    required this.dueDate,
    required this.state,
  });

  factory AssessmentOverviewViewModel.having({
    required String title,
    required int amountOfQuestions,
    required AnswersViewModel answers,
    required DueDateViewModel dueDate,
    AssessmentState? state,
  }) {
    return AssessmentOverviewViewModel(
      title: title,
      amountOfQuestions: amountOfQuestions,
      answers: answers,
      dueDate: dueDate,
      state: state ?? _buildState(answers.amountOfAnswers, answers.answerLimit),
    );
  }

  final String title;
  final int amountOfQuestions;
  final AnswersViewModel answers;
  final DueDateViewModel dueDate;
  final AssessmentState state;

  @override
  String toString() {
    return 'AssessmentsOverviewModel{ '
        'title: $title, '
        'amountOfQuestions: $amountOfQuestions, '
        'answers: $answers, '
        'dueDate: $dueDate, '
        'state: $state, '
        '}';
  }

  AssessmentOverviewViewModel copyWith({
    String? title,
    int? amountOfQuestions,
    AnswersViewModel? answers,
    bool? hasDueDate,
    DueDateViewModel? dueDate,
    AssessmentState? state,
  }) {
    return AssessmentOverviewViewModel(
      title: title ?? this.title,
      amountOfQuestions: amountOfQuestions ?? this.amountOfQuestions,
      answers: answers ?? this.answers,
      dueDate: dueDate ?? this.dueDate,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [
        title,
        amountOfQuestions,
        answers,
        dueDate,
      ];
}

class AnswersViewModel extends Equatable {
  const AnswersViewModel({
    required this.amountOfAnswers,
    required this.hasAnswerLimit,
    this.answerLimit,
  });

  factory AnswersViewModel.having({
    required int amountOfAnswers,
    int? answerLimit,
  }) {
    return AnswersViewModel(
      amountOfAnswers: amountOfAnswers,
      hasAnswerLimit: answerLimit != null,
      answerLimit: answerLimit,
    );
  }

  final int amountOfAnswers;
  final bool hasAnswerLimit;
  final int? answerLimit;

  @override
  String toString() {
    return 'Answers{ '
        'amountOfAnswers: $amountOfAnswers, '
        'hasAnswerLimit: $hasAnswerLimit, '
        'answerLimit: $answerLimit, '
        '}';
  }

  AnswersViewModel copyWith({
    int? amountOfAnswers,
    bool? hasAnswerLimit,
    int? answerLimit,
  }) {
    return AnswersViewModel(
      amountOfAnswers: amountOfAnswers ?? this.amountOfAnswers,
      hasAnswerLimit: hasAnswerLimit ?? this.hasAnswerLimit,
      answerLimit: answerLimit ?? this.answerLimit,
    );
  }

  @override
  List<Object?> get props => [
        amountOfAnswers,
        hasAnswerLimit,
        answerLimit,
      ];
}

class DueDateViewModel extends Equatable {
  const DueDateViewModel({
    required this.hasDueDate,
    this.dueDate,
  });

  factory DueDateViewModel.having({
    String? dueDate,
  }) {
    return DueDateViewModel(
      hasDueDate: dueDate != null,
      dueDate: dueDate,
    );
  }

  final bool hasDueDate;
  final String? dueDate;

  @override
  String toString() {
    return 'DueDateViewModel{ '
        'hasDueDate: $hasDueDate, '
        'dueDate: $dueDate, '
        '}';
  }

  DueDateViewModel copyWith({
    bool? hasDueDate,
    String? dueDate,
  }) {
    return DueDateViewModel(
      hasDueDate: hasDueDate ?? this.hasDueDate,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  List<Object?> get props => [
        hasDueDate,
        dueDate,
      ];
}

enum AssessmentState {
  inProgress,
  upcoming,
  finished,
}

AssessmentState _buildState(int amountOfAnswers, int? answerLimit) {
  if (answerLimit == null) {
    return AssessmentState.inProgress;
  }

  return amountOfAnswers >= answerLimit
      ? AssessmentState.finished
      : AssessmentState.inProgress;
}
