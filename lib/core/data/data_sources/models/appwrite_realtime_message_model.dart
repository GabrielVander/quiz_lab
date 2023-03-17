import 'package:appwrite/appwrite.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/data/data_sources/models/appwrite_question_option_model.dart';

class AppwriteRealtimeQuestionMessageModel extends Equatable {
  const AppwriteRealtimeQuestionMessageModel({
    required this.events,
    required this.channels,
    required this.timestamp,
    required this.payload,
  });

  factory AppwriteRealtimeQuestionMessageModel.fromRealtimeMessage(
    RealtimeMessage message,
  ) {
    return AppwriteRealtimeQuestionMessageModel(
      events: message.events,
      channels: message.channels,
      timestamp: message.timestamp,
      payload: AppwriteRealtimeQuestionPayloadModel.fromMap(message.payload),
    );
  }

  final List<String> events;
  final List<String> channels;
  final String timestamp;
  final AppwriteRealtimeQuestionPayloadModel payload;

  @override
  List<Object> get props => [
        events,
        channels,
        timestamp,
        payload,
      ];
}

class AppwriteRealtimeQuestionPayloadModel extends Equatable {
  const AppwriteRealtimeQuestionPayloadModel({
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

  factory AppwriteRealtimeQuestionPayloadModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return AppwriteRealtimeQuestionPayloadModel(
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

  final String id;
  final String createdAt;
  final String updatedAt;
  final List<String> permissions;
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
        permissions,
        collectionId,
        databaseId,
        title,
        description,
        difficulty,
        options,
        categories,
      ];
}
