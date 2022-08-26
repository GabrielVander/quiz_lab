import 'package:equatable/equatable.dart';

class AssessmentOverviewModel extends Equatable {
  const AssessmentOverviewModel({
    required this.title,
    required this.amountOfQuestions,
    required this.amountOfAnswers,
    required this.hasAnswerLimit,
    required this.answerLimit,
    required this.hasDueDate,
    required this.dueDate,
    required this.state,
  });

  factory AssessmentOverviewModel.having({
    required String title,
    required int amountOfQuestions,
    required int amountOfAnswers,
    int? answerLimit,
    String? dueDate,
    AssessmentState? state,
  }) {
    return AssessmentOverviewModel(
      title: title,
      amountOfQuestions: amountOfQuestions,
      amountOfAnswers: amountOfAnswers,
      hasAnswerLimit: answerLimit != null,
      answerLimit: answerLimit,
      hasDueDate: dueDate != null,
      dueDate: dueDate,
      state: state ?? _buildState(amountOfAnswers, answerLimit),
    );
  }

  final String title;
  final int amountOfQuestions;
  final int amountOfAnswers;
  final bool hasAnswerLimit;
  final int? answerLimit;
  final bool hasDueDate;
  final String? dueDate;
  final AssessmentState state;

  @override
  String toString() {
    return 'AssessmentsOverviewModel{ '
        'title: $title, '
        'amountOfQuestions: $amountOfQuestions, '
        'amountOfAnswers: $amountOfAnswers, '
        'hasAnswerLimit: $hasAnswerLimit, '
        'answerLimit: $answerLimit, '
        'hasDueDate: $hasDueDate, '
        'dueDate: $dueDate, '
        'state: $state, '
        '}';
  }

  AssessmentOverviewModel copyWith({
    String? title,
    int? amountOfQuestions,
    int? amountOfAnswers,
    bool? hasAnswerLimit,
    int? answerLimit,
    bool? hasDueDate,
    String? dueDate,
    AssessmentState? state,
  }) {
    return AssessmentOverviewModel(
      title: title ?? this.title,
      amountOfQuestions: amountOfQuestions ?? this.amountOfQuestions,
      amountOfAnswers: amountOfAnswers ?? this.amountOfAnswers,
      hasAnswerLimit: hasAnswerLimit ?? this.hasAnswerLimit,
      answerLimit: answerLimit ?? this.answerLimit,
      hasDueDate: hasDueDate ?? this.hasDueDate,
      dueDate: dueDate ?? this.dueDate,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [
        title,
        amountOfQuestions,
        amountOfAnswers,
        hasAnswerLimit,
        answerLimit,
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
