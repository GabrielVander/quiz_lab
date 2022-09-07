import 'package:flutter/material.dart';
import 'package:quiz_lab/features/quiz/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_category.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/quiz/domain/repositories/question_repository.dart';

class CreateQuestionUseCase {
  const CreateQuestionUseCase({
    required this.questionRepository,
  });

  final QuestionRepository questionRepository;

  Future<void> execute(QuestionCreationInput input) async {
    return questionRepository.createSingle(_inputToQuestionEntity(input));
  }

  Question _inputToQuestionEntity(QuestionCreationInput input) {
    return Question(
      shortDescription: _shortDescriptionFromInput(input),
      description: _descriptionFromInput(input),
      answerOptions: _answerOptionsFromInput(input),
      difficulty: _difficultyFromInput(input),
      categories: _categoriesFromInput(input),
    );
  }

  String _shortDescriptionFromInput(QuestionCreationInput input) =>
      input.shortDescription;

  String _descriptionFromInput(QuestionCreationInput input) =>
      input.description;

  List<AnswerOption> _answerOptionsFromInput(QuestionCreationInput input) => [];

  QuestionDifficulty _difficultyFromInput(QuestionCreationInput input) {
    final mappings = {
      QuestionDifficultyInput.easy: QuestionDifficulty.easy,
      QuestionDifficultyInput.medium: QuestionDifficulty.medium,
      QuestionDifficultyInput.hard: QuestionDifficulty.hard,
    };

    return mappings[input.difficulty] ?? QuestionDifficulty.unknown;
  }

  List<QuestionCategory> _categoriesFromInput(QuestionCreationInput input) {
    return input.categories.values
        .map((e) => QuestionCategory(value: e))
        .toList();
  }
}

@immutable
class QuestionCreationInput {
  const QuestionCreationInput({
    required this.shortDescription,
    required this.description,
    required this.difficulty,
    required this.categories,
  });

  final String shortDescription;
  final String description;
  final QuestionDifficultyInput difficulty;
  final QuestionCategoryInput categories;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionCreationInput &&
          runtimeType == other.runtimeType &&
          shortDescription == other.shortDescription &&
          description == other.description &&
          difficulty == other.difficulty &&
          categories == other.categories);

  @override
  int get hashCode =>
      shortDescription.hashCode ^
      description.hashCode ^
      difficulty.hashCode ^
      categories.hashCode;

  @override
  String toString() {
    return 'QuestionCreationInput{ '
        'shortDescription: $shortDescription, '
        'description: $description, '
        'difficulty: $difficulty, '
        'categories: $categories, '
        '}';
  }

  QuestionCreationInput copyWith({
    String? shortDescription,
    String? description,
    QuestionDifficultyInput? difficulty,
    QuestionCategoryInput? categories,
  }) {
    return QuestionCreationInput(
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      categories: categories ?? this.categories,
    );
  }
}

enum QuestionDifficultyInput { easy, medium, hard }

@immutable
class QuestionCategoryInput {
  const QuestionCategoryInput({
    required this.values,
  });

  final List<String> values;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionCategoryInput &&
          runtimeType == other.runtimeType &&
          values == other.values);

  @override
  int get hashCode => values.hashCode;

  @override
  String toString() {
    return 'CategoriesInput{ '
        'values: $values, '
        '}';
  }

  QuestionCategoryInput copyWith({
    List<String>? values,
  }) {
    return QuestionCategoryInput(
      values: values ?? this.values,
    );
  }
}
