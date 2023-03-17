import 'package:appwrite/models.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_option_model.dart';

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
  ) {
    return AppwriteQuestionModel(
      id: map[r'$id'] as String,
      createdAt: map[r'$createdAt'] as String,
      updatedAt: map[r'$updatedAt'] as String,
      permissions: map[r'$permissions'] as List<String>,
      collectionId: map[r'$collectionId'] as String,
      databaseId: map[r'$databaseId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      difficulty: map['difficulty'] as String,
      options: (map['options'] as List<Map<String, dynamic>>)
          .map(AppwriteQuestionOptionModel.fromMap)
          .toList(),
      categories: map['categories'] as List<String>,
    );
  }

  factory AppwriteQuestionModel.fromDocument(
    Document doc,
  ) {
    return AppwriteQuestionModel(
      id: doc.$id,
      createdAt: doc.$createdAt,
      updatedAt: doc.$updatedAt,
      permissions: null,
      collectionId: doc.$collectionId,
      databaseId: doc.$databaseId,
      title: doc.data['title'] as String,
      description: doc.data['description'] as String,
      difficulty: doc.data['difficulty'] as String,
      options: (doc.data['options'] as List<Map<String, dynamic>>)
          .map(AppwriteQuestionOptionModel.fromMap)
          .toList(),
      categories: doc.data['categories'] as List<String>,
    );
  }

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
  String toString() {
    return 'AppwriteQuestionModel{'
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
  }
}
