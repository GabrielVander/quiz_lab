import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_permission_model.dart';
import 'package:quiz_lab/features/question_management/data/data_sources/models/appwrite_question_option_model.dart';

class AppwriteQuestionCreationModel extends Equatable {
  const AppwriteQuestionCreationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.options,
    required this.categories,
    this.permissions,
  });

  final String id;
  final String title;
  final String description;
  final String difficulty;
  final List<AppwriteQuestionOptionModel> options;
  final List<String> categories;
  final List<AppwritePermissionTypeModel>? permissions;

  @override
  List<Object> get props => [
        id,
        title,
        description,
        difficulty,
        options,
        categories,
        permissions ?? [],
      ];

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'difficulty': difficulty,
        'options': jsonEncode(options.map((o) => o.toMap()).toList()),
        'categories': categories,
      };
}
