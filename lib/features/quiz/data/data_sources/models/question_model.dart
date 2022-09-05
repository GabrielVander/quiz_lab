import 'package:flutter/foundation.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_category.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_difficulty.dart';

@immutable
class QuestionModel {
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
      shortDescription: map['shortDescription'] as String,
      description: map['description'] as String,
      difficulty: map['difficulty'] as String,
      categories: List<String>.from(map['categories'] as List<dynamic>),
    );
  }

  final String id;
  final String shortDescription;
  final String description;
  final String difficulty;
  final List<String> categories;

  //<editor-fold desc="Data Methods">

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          shortDescription == other.shortDescription &&
          description == other.description &&
          difficulty == other.difficulty &&
          categories == other.categories);

  @override
  int get hashCode =>
      id.hashCode ^
      shortDescription.hashCode ^
      description.hashCode ^
      difficulty.hashCode ^
      categories.hashCode;

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

  QuestionModel copyWith({
    String? id,
    String? shortDescription,
    String? description,
    String? difficulty,
    List<String>? categories,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      categories: categories ?? this.categories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shortDescription': shortDescription,
      'description': description,
      'difficulty': difficulty,
      'categories': categories,
    };
  }

//</editor-fold>

  Question toEntity() {
    return Question(
      id: id,
      shortDescription: shortDescription,
      description: description,
      answerOptions: [],
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
}
