import 'package:flutter/foundation.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question.dart';
import 'package:quiz_lab/features/quiz/domain/entities/question_difficulty.dart';

@immutable
class QuestionModel {
  const QuestionModel({
    required this.shortDescription,
    required this.description,
    required this.difficulty,
    required this.categories,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      shortDescription: map['shortDescription'] as String,
      description: map['description'] as String,
      difficulty: map['difficulty'] as String,
      categories: map['categories'] as List<String>,
    );
  }

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
    return 'QuestionModel{ '
        'shortDescription: $shortDescription, '
        'description: $description, '
        'difficulty: $difficulty, '
        'categories: $categories, '
        '}';
  }

  QuestionModel copyWith({
    String? shortDescription,
    String? description,
    String? difficulty,
    List<String>? categories,
  }) {
    return QuestionModel(
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      categories: categories ?? this.categories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shortDescription': shortDescription,
      'description': description,
      'difficulty': difficulty,
      'categories': categories,
    };
  }

//</editor-fold>

  Question toEntity() {
    return const Question(
      id: 'id',
      shortDescription: 'shortDescription',
      description: 'description',
      answerOptions: [],
      difficulty: QuestionDifficulty.medium,
      categories: [],
    );
  }
}
