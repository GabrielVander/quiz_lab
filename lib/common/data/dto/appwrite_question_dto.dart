import 'dart:convert';

import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/dto/appwrite_question_option_dto.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_owner.dart';

class AppwriteQuestionDto extends Equatable {
  const AppwriteQuestionDto({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.collectionId,
    required this.databaseId,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.options,
    required this.categories,
    required this.profile,
  });

  factory AppwriteQuestionDto.fromMap(Map<String, dynamic> map) => AppwriteQuestionDto(
        id: map[r'$id'] as String,
        createdAt: map[r'$createdAt'] as String,
        updatedAt: map[r'$updatedAt'] as String,
        collectionId: map[r'$collectionId'] as String,
        databaseId: map[r'$databaseId'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        difficulty: map['difficulty'] as String,
        options: (jsonDecode(map['options'] as String) as List<dynamic>)
            .map((o) => AppwriteQuestionOptionDto.fromMap(o as Map<String, dynamic>))
            .toList(),
        categories: (map['categories'] as List<dynamic>).map((c) => c as String).toList(),
        profile: map['profile_'] as String?,
      );

  factory AppwriteQuestionDto.fromDocument(Document doc) => AppwriteQuestionDto(
        id: doc.$id,
        createdAt: doc.$createdAt,
        updatedAt: doc.$updatedAt,
        collectionId: doc.$collectionId,
        databaseId: doc.$databaseId,
        title: doc.data['title'] as String,
        description: doc.data['description'] as String,
        difficulty: doc.data['difficulty'] as String,
        options: (jsonDecode(doc.data['options'] as String) as List<dynamic>)
            .map((o) => o as Map<String, dynamic>)
            .map(AppwriteQuestionOptionDto.fromMap)
            .toList(),
        categories: (doc.data['categories'] as List<dynamic>)
            .map((c) => c as String?)
            .where((c) => c != null)
            .map((c) => c!)
            .toList(),
        profile: doc.data['profile_'] as String?,
      );

  final String id;
  final String createdAt;
  final String updatedAt;
  final String collectionId;
  final String databaseId;
  final String title;
  final String description;
  final String difficulty;
  final List<AppwriteQuestionOptionDto> options;
  final List<String> categories;
  final String? profile;

  @override
  List<Object?> get props => [
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
        profile,
      ];

  @override
  String toString() => 'AppwriteQuestionDto{'
      'id: $id, '
      'createdAt: $createdAt, '
      'updatedAt: $updatedAt, '
      'collectionId: $collectionId, '
      'databaseId: $databaseId, '
      'title: $title, '
      'description: $description, '
      'difficulty: $difficulty, '
      'options: $options, '
      'categories: $categories'
      'profile: $profile'
      '}';

  Question toQuestion() => Question(
        id: QuestionId(id),
        shortDescription: title,
        description: description,
        difficulty: _mapDifficulty(difficulty),
        answerOptions: options.map((o) => o.toAnswerOption()).toList(),
        categories: categories.map((c) => QuestionCategory(value: c)).toList(),
        owner: profile != null ? QuestionOwner(displayName: profile!) : null,
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

  AppwriteQuestionDto copyWith({
    String? id,
    String? createdAt,
    String? updatedAt,
    String? collectionId,
    String? databaseId,
    String? title,
    String? description,
    String? difficulty,
    List<AppwriteQuestionOptionDto>? options,
    List<String>? categories,
    String? profile,
  }) =>
      AppwriteQuestionDto(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        collectionId: collectionId ?? this.collectionId,
        databaseId: databaseId ?? this.databaseId,
        title: title ?? this.title,
        description: description ?? this.description,
        difficulty: difficulty ?? this.difficulty,
        options: options ?? this.options,
        categories: categories ?? this.categories,
        profile: profile ?? this.profile,
      );
}
