import 'dart:convert';

import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_option_model.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';

class AppwriteQuestionModel extends Equatable {
  const AppwriteQuestionModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.permissions,
    required this.collectionId,
    required this.databaseId,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.options,
    required this.categories,
  });

  factory AppwriteQuestionModel.fromMap(
    Map<String, dynamic> map,
  ) =>
      AppwriteQuestionModel(
        id: map[r'$id'] as String,
        createdAt: map[r'$createdAt'] as String,
        updatedAt: map[r'$updatedAt'] as String,
        permissions: (map[r'$permissions'] as List<dynamic>).map((p) => p as String).toList(),
        collectionId: map[r'$collectionId'] as String,
        databaseId: map[r'$databaseId'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        difficulty: map['difficulty'] as String,
        options: (jsonDecode(map['options'] as String) as List<dynamic>)
            .map(
              (o) => AppwriteQuestionOptionModel.fromMap(
                o as Map<String, dynamic>,
              ),
            )
            .toList(),
        categories: (map['categories'] as List<dynamic>).map((c) => c as String).toList(),
      );

  factory AppwriteQuestionModel.fromDocument(
    Document doc,
  ) =>
      AppwriteQuestionModel(
        id: doc.$id,
        createdAt: doc.$createdAt,
        updatedAt: doc.$updatedAt,
        permissions: null,
        collectionId: doc.$collectionId,
        databaseId: doc.$databaseId,
        title: doc.data['title'] as String,
        description: doc.data['description'] as String,
        difficulty: doc.data['difficulty'] as String,
        options: (jsonDecode(doc.data['options'] as String) as List<dynamic>)
            .map((o) => o as Map<String, dynamic>)
            .map(AppwriteQuestionOptionModel.fromMap)
            .toList(),
        categories: (doc.data['categories'] as List<dynamic>)
            .map((c) => c as String?)
            .where((c) => c != null)
            .map((c) => c!)
            .toList(),
      );

  final String id;
  final String createdAt;
  final String updatedAt;
  final List<String>? permissions;
  final String collectionId;
  final String databaseId;
  final String title;
  final String description;
  final String difficulty;
  final List<AppwriteQuestionOptionModel> options;
  final List<String> categories;

  @override
  List<Object> get props => [
        id,
        createdAt,
        updatedAt,
        collectionId,
        databaseId,
        title,
        description,
        difficulty,
        options,
        categories,
      ];

  @override
  String toString() => 'AppwriteQuestionModel{'
      'id: $id, '
      'createdAt: $createdAt, '
      'updatedAt: $updatedAt, '
      'permissions: $permissions, '
      'collectionId: $collectionId, '
      'databaseId: $databaseId, '
      'title: $title, '
      'description: $description, '
      'difficulty: $difficulty, '
      'options: $options, '
      'categories: $categories'
      '}';

  Question toQuestion() => Question(
        id: QuestionId(id),
        shortDescription: title,
        description: description,
        difficulty: _mapDifficulty(difficulty),
        answerOptions: options.map((o) => o.toAnswerOption()).toList(),
        categories: categories.map((c) => QuestionCategory(value: c)).toList(),
      );

  QuestionDifficulty _mapDifficulty(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return QuestionDifficulty.easy;
      case 'medium':
        return QuestionDifficulty.medium;
      case 'hard':
        return QuestionDifficulty.hard;
      default:
        return QuestionDifficulty.unknown;
    }
  }
}
