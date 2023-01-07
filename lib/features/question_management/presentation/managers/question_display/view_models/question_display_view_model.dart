import 'package:flutter/foundation.dart';

@immutable
class QuestionDisplayViewModel {
  const QuestionDisplayViewModel({
    required this.title,
    required this.difficulty,
    required this.description,
    required this.options,
    required this.answerButtonIsEnabled,
  });

  final String title;
  final String difficulty;
  final String description;
  final List<QuestionDisplayOptionViewModel> options;
  final bool answerButtonIsEnabled;

  QuestionDisplayViewModel copyWith({
    String? title,
    String? difficulty,
    String? description,
    List<QuestionDisplayOptionViewModel>? options,
    bool? answerButtonIsEnabled,
  }) {
    return QuestionDisplayViewModel(
      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,
      description: description ?? this.description,
      options: options ?? this.options,
      answerButtonIsEnabled:
          answerButtonIsEnabled ?? this.answerButtonIsEnabled,
    );
  }
}

@immutable
class QuestionDisplayOptionViewModel {
  const QuestionDisplayOptionViewModel({
    required this.title,
    required this.isSelected,
    required this.isCorrect,
  });

  final String title;
  final bool isSelected;
  final bool isCorrect;

  QuestionDisplayOptionViewModel copyWith({
    String? title,
    bool? isSelected,
    bool? isCorrect,
  }) {
    return QuestionDisplayOptionViewModel(
      title: title ?? this.title,
      isSelected: isSelected ?? this.isSelected,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
