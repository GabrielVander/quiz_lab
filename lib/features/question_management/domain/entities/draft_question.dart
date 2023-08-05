import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';

class DraftQuestion extends Equatable {
  const DraftQuestion({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.options,
    required this.categories,
  });

  final String title;
  final String description;
  final String difficulty;
  final List<AnswerOption> options;
  final List<QuestionCategory> categories;

  @override
  List<Object> get props => [
        title,
        description,
        difficulty,
        options,
        categories,
      ];

  @override
  String toString() {
    return 'DraftQuestion{'
        'shortDescription: $title, '
        'description: $description, '
        'difficulty: $difficulty, '
        'options: $options, '
        'categories: $categories'
        '}';
  }
}
