import 'package:flutter/material.dart';

import '../entities/answer_option.dart';
import '../entities/question.dart';
import '../entities/question_category.dart';
import '../entities/question_difficulty.dart';
import '../repositories/question_repository.dart';

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
  String toString() {
    return 'QuestionCreationInput{ '
        'shortDescription: $shortDescription, '
        'description: $description, '
        'difficulty: $difficulty, '
        'categories: $categories, '
        '}';
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
  String toString() {
    return 'CategoriesInput{ '
        'values: $values, '
        '}';
  }
}
