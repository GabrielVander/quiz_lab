import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'answer_option.dart';
import 'question_category.dart';
import 'question_difficulty.dart';

class Question extends Equatable {
  Question({
    String? id,
    required this.shortDescription,
    required this.description,
    required this.answerOptions,
    required this.difficulty,
    required this.categories,
  }) {
    this.id = id ?? const Uuid().v4();
  }

  late final String id;
  final String shortDescription;
  final String description;
  final List<AnswerOption> answerOptions;
  final QuestionDifficulty difficulty;
  final List<QuestionCategory> categories;

  @override
  String toString() {
    return 'Question{ '
        'id: $id, '
        'shortDescription: $shortDescription, '
        'description: $description, '
        'answerOptions: $answerOptions, '
        'difficulty: $difficulty, '
        'categories: $categories, '
        '}';
  }

  Question copyWith({
    String? shortDescription,
    String? description,
    List<AnswerOption>? answerOptions,
    QuestionDifficulty? difficulty,
    List<QuestionCategory>? categories,
  }) {
    return Question(
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      answerOptions: answerOptions ?? this.answerOptions,
      difficulty: difficulty ?? this.difficulty,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [
        id,
        shortDescription,
        description,
        answerOptions,
        difficulty,
        categories,
      ];
}
