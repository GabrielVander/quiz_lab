import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';

class DraftQuestion extends Equatable {
  const DraftQuestion({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.options,
    required this.categories,
    this.isPublic = false,
  });

  final String title;
  final String description;
  final QuestionDifficulty difficulty;
  final List<AnswerOption> options;
  final List<QuestionCategory> categories;
  final bool isPublic;

  @override
  List<Object> get props => [
        title,
        description,
        difficulty,
        options,
        categories,
        isPublic,
      ];

  @override
  String toString() {
    return 'DraftQuestion{'
        'shortDescription: $title, '
        'description: $description, '
        'difficulty: $difficulty, '
        'options: $options, '
        'categories: $categories'
        'isPublic: $isPublic'
        '}';
  }
}
