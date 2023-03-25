import 'package:quiz_lab/features/question_management/data/data_sources/models/hive_question_model.dart';
import 'package:quiz_lab/features/question_management/domain/entities/question.dart';

class HiveQuestionModelMapper {
  HiveQuestionModel fromQuestion(
    Question question,
  ) =>
      HiveQuestionModel(
        id: _parseIdFromQuestion(question),
        shortDescription: _parseShortDescriptionFromQuestion(question),
        description: _parseDescriptionFromQuestion(question),
        difficulty: _parseDifficultyFromQuestion(question),
        options: _parseOptionsFromQuestion(question),
        categories: _parseCategoriesFromQuestion(question),
      );

  String? _parseIdFromQuestion(Question question) => question.id.value;

  String _parseDescriptionFromQuestion(Question question) =>
      question.description;

  String _parseShortDescriptionFromQuestion(Question question) =>
      question.shortDescription;

  String _parseDifficultyFromQuestion(Question question) =>
      question.difficulty.name;

  List<Map<String, dynamic>> _parseOptionsFromQuestion(Question question) =>
      question.answerOptions
          .map((a) => {'description': a.description, 'isCorrect': a.isCorrect})
          .toList();

  List<String> _parseCategoriesFromQuestion(Question question) =>
      question.categories.map((e) => e.value).toList();
}
