import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_category.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_difficulty.dart';

@immutable
class QuestionModel extends Equatable {
  const QuestionModel({
    required this.id,
    required this.shortDescription,
    required this.description,
    required this.difficulty,
    required this.categories,
  });

  factory QuestionModel.fromMap(String id, Map<String, dynamic> map) {
    return QuestionModel(
      id: id,
      shortDescription: map['shortDescription'] as String? ?? '',
      description: map['description'] as String? ?? '',
      difficulty: map['difficulty'] as String? ?? '',
      categories: List<String>.from(map['categories'] as List<dynamic>? ?? []),
    );
  }

  factory QuestionModel.fromEntity(Question entity) {
    return QuestionModel(
      id: entity.id,
      shortDescription: entity.shortDescription,
      description: entity.description,
      difficulty: entity.difficulty.name,
      categories: entity.categories.map((e) => e.value).toList(),
    );
  }

  final String? id;
  final String shortDescription;
  final String description;
  final String difficulty;
  final List<String> categories;

  @override
  String toString() {
    return 'QuestionModel{ '
        'id: $id, '
        'shortDescription: $shortDescription, '
        'description: $description, '
        'difficulty: $difficulty, '
        'categories: $categories, '
        '}';
  }

  Map<String, dynamic> toMap() {
    return {
      'shortDescription': shortDescription,
      'description': description,
      'difficulty': difficulty,
      'categories': categories,
    };
  }

  Question toEntity() {
    return Question(
      id: id,
      shortDescription: shortDescription,
      description: description,
      answerOptions: const [],
      difficulty: _difficultyFromStr(),
      categories: categories.map((c) => QuestionCategory(value: c)).toList(),
    );
  }

  QuestionDifficulty _difficultyFromStr() {
    if (difficulty == 'easy') {
      return QuestionDifficulty.easy;
    }
    if (difficulty == 'medium') {
      return QuestionDifficulty.medium;
    }
    if (difficulty == 'hard') {
      return QuestionDifficulty.hard;
    }

    return QuestionDifficulty.unknown;
  }

  @override
  List<Object?> get props => [
        id,
        shortDescription,
        description,
        difficulty,
        categories,
      ];
}
