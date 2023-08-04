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

  Question copyWith({
    QuestionId? id,
    String? shortDescription,
    String? description,
    List<AnswerOption>? answerOptions,
    QuestionDifficulty? difficulty,
    List<QuestionCategory>? categories,
    bool? isPublic,
  }) {
    return Question(
      id: id ?? this.id,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      answerOptions: answerOptions ?? this.answerOptions,
      difficulty: difficulty ?? this.difficulty,
      categories: categories ?? this.categories,
      isPublic: isPublic ?? this.isPublic,
    );
  }

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
}

class QuestionId extends Equatable {
  const QuestionId(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}
