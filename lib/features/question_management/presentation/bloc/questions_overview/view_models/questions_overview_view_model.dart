import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_lab/common/domain/entities/question.dart';
import 'package:quiz_lab/common/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_owner.dart';

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
      isRandomQuestionButtonEnabled: isRandomQuestionButtonEnabled ?? this.isRandomQuestionButtonEnabled,
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
    required this.owner,
  });

  factory QuestionsOverviewItemViewModel.fromQuestion(Question question) => QuestionsOverviewItemViewModel(
        id: question.id.value,
        shortDescription: question.shortDescription,
        description: question.description,
        categories: question.categories.map((c) => c.value).toList(),
        difficulty: question.difficulty.name,
        owner: question.owner?.displayName,
      );

  final String id;
  final String shortDescription;
  final String description;
  final List<String> categories;
  final String difficulty;
  final String? owner;

  Question toQuestion() => Question(
        id: QuestionId(id),
        shortDescription: shortDescription,
        description: description,
        categories: categories.map((c) => QuestionCategory(value: c)).toList(),
        difficulty: QuestionDifficulty.values.firstWhere(
          (d) => d.name == difficulty,
          orElse: () => QuestionDifficulty.unknown,
        ),
        answerOptions: const [],
        owner: owner != null ? QuestionOwner(displayName: owner!) : null,
      );

  @override
  List<Object?> get props => [
        id,
        shortDescription,
        description,
        categories,
        difficulty,
        owner,
      ];

  @override
  String toString() {
    return 'QuestionsOverviewItemViewModel{'
        'id: $id, '
        'shortDescription: $shortDescription, '
        'description: $description, '
        'categories: $categories, '
        'difficulty: $difficulty'
        'owner: $owner'
        '}';
  }
}
