import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class HiveQuestionModel extends Equatable {
  const HiveQuestionModel({
    required this.id,
    required this.shortDescription,
    required this.description,
    required this.difficulty,
    required this.options,
    required this.categories,
  });

  factory HiveQuestionModel.fromMap(String id, Map<String, dynamic> map) {
    return HiveQuestionModel(
      id: id,
      shortDescription: map['shortDescription'] as String? ?? '',
      description: map['description'] as String? ?? '',
      difficulty: map['difficulty'] as String? ?? '',
      options: List<Map<String, dynamic>>.from(
        map['options'] as List<dynamic>? ?? [],
      ),
      categories: List<String>.from(map['categories'] as List<dynamic>? ?? []),
    );
  }

  final String? id;
  final String? shortDescription;
  final String? description;
  final String? difficulty;
  final List<Map<String, dynamic>>? options;
  final List<String>? categories;

  Map<String, dynamic> toMap() {
    return {
      'shortDescription': shortDescription,
      'description': description,
      'difficulty': difficulty,
      'options': options,
      'categories': categories,
    };
  }

  @override
  List<Object?> get props => [
        id,
        shortDescription,
        description,
        difficulty,
        options,
        categories,
      ];

  @override
  bool get stringify => true;
}
