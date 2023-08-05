import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';

class Question extends Equatable {
  const Question({
    required this.id,
    required this.shortDescription,
    required this.description,
    required this.answerOptions,
    required this.difficulty,
    required this.categories,
    this.isPublic = false,
  });

  final QuestionId id;
  final String shortDescription;
  final String description;
  final List<AnswerOption> answerOptions;
  final QuestionDifficulty difficulty;
  final List<QuestionCategory> categories;
  final bool isPublic;

  @override
  String toString() {
    return 'Question{'
        'id: $id, '
        'shortDescription: $shortDescription, '
        'description: $description, '
        'answerOptions: $answerOptions, '
        'difficulty: $difficulty, '
        'categories: $categories, '
        'isPublic: $isPublic'
        '}';
  }

  @override
  List<Object?> get props => [
        id,
        shortDescription,
        description,
        answerOptions,
        difficulty,
        categories,
        isPublic,
      ];

  @override
  bool get stringify => false;
}

class QuestionId extends Equatable {
  const QuestionId(this.value);

  final String value;

  @override
  List<Object> get props => [value];

  @override
  String toString() {
    return 'QuestionId{value: $value}';
  }
}
