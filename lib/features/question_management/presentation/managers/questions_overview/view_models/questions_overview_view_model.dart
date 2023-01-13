import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class QuestionsOverviewViewModel {
  const QuestionsOverviewViewModel({
    required this.questions,
    required this.isRandomQuestionButtonEnabled,
  });

  final List<QuestionsOverviewItemViewModel> questions;
  final bool isRandomQuestionButtonEnabled;

  QuestionsOverviewViewModel copyWith({
    List<QuestionsOverviewItemViewModel>? questions,
    bool? isRandomQuestionButtonEnabled,
  }) {
    return QuestionsOverviewViewModel(
      questions: questions ?? this.questions,
      isRandomQuestionButtonEnabled:
          isRandomQuestionButtonEnabled ?? this.isRandomQuestionButtonEnabled,
    );
  }
}

class QuestionsOverviewItemViewModel extends Equatable {
  const QuestionsOverviewItemViewModel({
    required this.id,
    required this.shortDescription,
    required this.description,
    required this.categories,
    required this.difficulty,
  });

  final String id;
  final String shortDescription;
  final String description;
  final List<String> categories;
  final String difficulty;

  QuestionsOverviewItemViewModel copyWith({
    String? id,
    String? shortDescription,
    String? description,
    List<String>? categories,
    String? difficulty,
  }) {
    return QuestionsOverviewItemViewModel(
      id: id ?? this.id,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  List<Object?> get props => [
        id,
        shortDescription,
        description,
        categories,
        difficulty,
      ];

  @override
  bool get stringify => true;
}
