import 'package:equatable/equatable.dart';
import 'package:okay/okay.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/core/utils/unit.dart';

class AnswerableQuestion extends Equatable {
  const AnswerableQuestion({
    required this.id,
    required this.title,
    required this.description,
    required this.answers,
    required this.difficulty,
  });

  final String id;
  final String title;
  final String description;
  final List<Answer> answers;
  final QuestionDifficulty difficulty;

  @override
  String toString() => 'AnswerableQuestion{'
      'id: $id, '
      'title: $title, '
      'description: $description, '
      'answers: $answers, '
      'difficulty: $difficulty, '
      '}';

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        answers,
        difficulty,
      ];

  Result<QuestionResult, AnswerFailure> answerWith(String answerId) {
    final correctAnswersIds = answers.where((answer) => answer.isCorrect).map((e) => e.id);

    return _performValidations(answerId, correctAnswersIds).map(
      (_) => QuestionResult(
        answeredCorrectly: correctAnswersIds.contains(answerId),
        correctAnswersIds: correctAnswersIds.toList(),
      ),
    );
  }

  Result<Unit, AnswerFailure> _performValidations(String answerId, Iterable<String> correctAnswersIds) {
    if (answers.isEmpty) return Err(NoAnswersFailure());
    if (correctAnswersIds.isEmpty) return Err(NoCorrectAnswerFailure());
    if (!answers.any((answer) => answer.id == answerId)) return Err(AnswerNotFoundFailure(answerId));

    return const Ok(unit);
  }
}

class Answer extends Equatable {
  const Answer({
    required this.id,
    required this.description,
    required this.isCorrect,
  });

  final String id;
  final String description;
  final bool isCorrect;

  @override
  String toString() => 'Answer { '
      'id: $id, '
      'description: $description, '
      'isCorrect: $isCorrect, '
      '}';

  @override
  List<Object?> get props => [
        id,
        description,
        isCorrect,
      ];
}

class QuestionResult extends Equatable {
  const QuestionResult({
    required this.answeredCorrectly,
    required this.correctAnswersIds,
  });

  final bool answeredCorrectly;
  final List<String> correctAnswersIds;

  @override
  String toString() => 'QuestionResult { '
      'answeredCorrectly: $answeredCorrectly, '
      'correctAnswers: $correctAnswersIds'
      '}';

  @override
  List<Object?> get props => [
        answeredCorrectly,
        correctAnswersIds,
      ];
}

sealed class AnswerFailure extends Equatable {}

class AnswerNotFoundFailure extends AnswerFailure {
  AnswerNotFoundFailure(this.answerId);

  final String answerId;

  @override
  String toString() => 'AnswerNotFoundFailure { answerId: $answerId }';

  @override
  List<Object?> get props => [answerId];
}

class NoCorrectAnswerFailure extends AnswerFailure {
  NoCorrectAnswerFailure();

  @override
  String toString() => 'NoCorrectAnswerFailure{}';

  @override
  List<Object?> get props => [];
}

class NoAnswersFailure extends AnswerFailure {
  NoAnswersFailure();

  @override
  String toString() => 'NoAnswersFailure{}';

  @override
  List<Object?> get props => [];
}
