import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';

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

  factory QuestionsOverviewItemViewModel.fromQuestion(Question question) =>
      QuestionsOverviewItemViewModel(
        id: question.id.value,
        shortDescription: question.shortDescription,
        description: question.description,
        categories: question.categories.map((c) => c.value).toList(),
        difficulty: question.difficulty.name,
      );

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
  }) =>
      QuestionsOverviewItemViewModel(
        id: id ?? this.id,
        shortDescription: shortDescription ?? this.shortDescription,
        description: description ?? this.description,
        categories: categories ?? this.categories,
        difficulty: difficulty ?? this.difficulty,
      );

  Question toQuestion() => Question(
        id: QuestionId(id),
        shortDescription: shortDescription,
        description: description,
        categories: categories.map((c) => QuestionCategory(value: c)).toList(),
        difficulty: QuestionDifficulty.values.firstWhere(
          (d) => describeEnum(d) == difficulty,
          orElse: () => QuestionDifficulty.unknown,
        ),
        answerOptions: const [],
      );

  @override
  List<Object?> get props => [
        id,
        shortDescription,
        description,
        categories,
        difficulty,
      ];

  @override
  String toString() {
    return 'QuestionsOverviewItemViewModel{'
        'id: $id, '
        'shortDescription: $shortDescription, '
        'description: $description, '
        'categories: $categories, '
        'difficulty: $difficulty'
        '}';
  }
}
