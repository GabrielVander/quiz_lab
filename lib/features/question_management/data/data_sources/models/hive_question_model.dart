import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class HiveQuestionModel extends Equatable {
  const HiveQuestionModel({
    required this.id,
    required this.shortDescription,
    required this.description,
    required this.difficulty,
    required this.categories,
  });

  factory HiveQuestionModel.fromMap(String id, Map<String, dynamic> map) {
    return HiveQuestionModel(
      id: id,
      shortDescription: map['shortDescription'] as String? ?? '',
      description: map['description'] as String? ?? '',
      difficulty: map['difficulty'] as String? ?? '',
      categories: List<String>.from(map['categories'] as List<dynamic>? ?? []),
    );
  }

  final String? id;
  final String? shortDescription;
  final String? description;
  final String? difficulty;
  final List<String>? categories;

  Map<String, dynamic> toMap() {
    return {
      'shortDescription': shortDescription,
      'description': description,
      'difficulty': difficulty,
      'categories': categories
    };
  }

  @override
  List<Object?> get props => [
        id,
        shortDescription,
        description,
        difficulty,
        categories,
      ];

  @override
  bool get stringify => true;
}
