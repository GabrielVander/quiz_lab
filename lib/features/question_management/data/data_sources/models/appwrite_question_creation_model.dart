import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_permission_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_option_model.dart';

class AppwriteQuestionCreationModel extends Equatable {
  const AppwriteQuestionCreationModel({
    required this.ownerId,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.options,
    required this.categories,
    this.permissions,
  });

  final String title;
  final String description;
  final String difficulty;
  final List<AppwriteQuestionOptionModel> options;
  final List<String> categories;
  final String? ownerId;
  final List<AppwritePermissionTypeModel>? permissions;

  @override
  List<Object?> get props => [
        ownerId,
        title,
        description,
        difficulty,
        options,
        categories,
        permissions,
      ];

  Map<String, dynamic> toMap() => {
        'profile': ownerId,
        'profile_': ownerId,
        'title': title,
        'description': description,
        'difficulty': difficulty,
        'options': jsonEncode(options.map((o) => o.toMap()).toList()),
        'categories': categories,
      };
}
