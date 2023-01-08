import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class QuestionDisplayViewModel extends Equatable {
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

  @override
  List<Object?> get props => [
        title,
        difficulty,
        description,
        options,
        answerButtonIsEnabled,
      ];
}

@immutable
class QuestionDisplayOptionViewModel extends Equatable {
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

  @override
  List<Object?> get props => [
        title,
        isSelected,
        isCorrect,
      ];
}
