import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_category.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_difficulty.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question_owner.dart';

class Question extends Equatable {
  const Question({
    required this.id,
    required this.shortDescription,
    required this.description,
    required this.answerOptions,
    required this.difficulty,
    required this.categories,
    this.isPublic = false,
    this.owner,
  });

  final QuestionId id;
  final String shortDescription;
  final String description;
  final List<AnswerOption> answerOptions;
  final QuestionDifficulty difficulty;
  final List<QuestionCategory> categories;
  final bool isPublic;
  final QuestionOwner? owner;

  @override
  String toString() => 'Question{'
      'id: $id, '
      'shortDescription: $shortDescription, '
      'description: $description, '
      'answerOptions: $answerOptions, '
      'difficulty: $difficulty, '
      'categories: $categories, '
      'isPublic: $isPublic'
      'owner: $owner'
      '}';

  @override
  List<Object?> get props => [
        id,
        shortDescription,
        description,
        answerOptions,
        difficulty,
        categories,
        isPublic,
        owner,
      ];

  @override
  bool get stringify => false;
}

class QuestionId extends Equatable {
  const QuestionId(this.value);

  final String value;

  @override
  List<Object> get props => [value];

  @override
  String toString() {
    return 'QuestionId{value: $value}';
  }
}
