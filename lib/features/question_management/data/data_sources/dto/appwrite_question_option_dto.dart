import 'package:equatable/equatable.dart';
import 'package:quiz_lab/features/question_management/domain/entities/answer_option.dart';

class AppwriteQuestionOptionDto extends Equatable {
  const AppwriteQuestionOptionDto({
    required this.description,
    required this.isCorrect,
  });

  factory AppwriteQuestionOptionDto.fromMap(Map<String, dynamic> map) {
    return AppwriteQuestionOptionDto(
      description: map['description'] as String,
      isCorrect: map['isCorrect'] as bool,
    );
  }

  final String description;
  final bool isCorrect;

  @override
  List<Object> get props => [
        description,
        isCorrect,
      ];

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'isCorrect': isCorrect,
    };
  }

  AnswerOption toAnswerOption() => AnswerOption(
        description: description,
        isCorrect: isCorrect,
      );
}
